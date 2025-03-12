import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/features/album/domain/entities/album.dart';
import 'package:graduation_thesis_front_end/features/search/domain/entities/filter.dart';
import 'package:provider/provider.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/person_group.dart';

class SearchProvider extends ChangeNotifier {
  // State
  FilterOption? _selectedFilter;
  List<Photo> _searchResults = [];
  final List<Photo> _photoList;
  final List<Album> _albumList;
  final List<PersonGroup> _personGroupList;
  bool _isVoiceSearchOn = false;

  static List<String> timeRangeOption = [
    'Today',
    'Yesterday',
    'This Week',
    'Last Week',
    'Last 30 days',
    'This Month',
    'Last Month',
    'This Year',
    'Last Year',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  List<PersonGroup> get personGroupList => _personGroupList;

  SearchProvider({
    required List<Photo> photoList,
    required List<Album> albumList,
    required List<PersonGroup> personGroupList,
  })  : _photoList = photoList,
        _albumList = albumList,
        _personGroupList = personGroupList {
    _populateFilterOptions();
  }

  // Getter
  FilterOption? get selectedFilter => _selectedFilter;
  List<Photo> get searchResults => _searchResults;
  bool get isVoiceSearchOn => _isVoiceSearchOn;

  // utils
  // get 2 random time range filter with 1 random photo in that time range-> give back {timeRange, timerange}
  List<Map<String, dynamic>> getRandomTimeRangeFilter() {
    // Tạo một bản sao của danh sách timeRangeOption và xáo trộn nó
    final shuffledTimeRanges = List<String>.from(timeRangeOption)..shuffle();

    // List để lưu các filter có ảnh
    final List<Map<String, dynamic>> filtersWithPhotos = [];

    // Duyệt qua tất cả các time range đã xáo trộn
    for (var filter in shuffledTimeRanges) {
      // Kiểm tra xem filter này có ảnh không
      final photos = _searchByTimeRange(filter);
      if (photos.isNotEmpty) {
        // Thêm filter và URL của ảnh đầu tiên vào danh sách
        filtersWithPhotos
            .add({'filter': filter, 'url': photos[0].imageUrl ?? ''});

        // Nếu đã tìm thấy 2 filter có ảnh, dừng lại
        if (filtersWithPhotos.length == 2) break;
      }
    }

    // Trả về danh sách các filter có ảnh (có thể là 0, 1, hoặc 2)
    return filtersWithPhotos;
  }

  // get all smart tag from image
  List<String> getAllSmartTag() {
    final Set<String> smartTags = {};
    for (var photo in _photoList) {
      if (photo.labels.labels.locationLabels.isNotEmpty) {
        smartTags.add(photo.labels.labels.locationLabels[0].label);
      }

      if (photo.labels.labels.eventLabels.isNotEmpty) {
        smartTags.add(photo.labels.labels.eventLabels[0].label);
      }

      if (photo.labels.labels.actionLabels.isNotEmpty) {
        smartTags.add(photo.labels.labels.actionLabels[0].label);
      }
    }
    return smartTags.toList();
  }

  // Tìm kiếm ảnh dựa trên bộ lọc
  List<Photo> _searchPhotos(FilterOption filter) {
    switch (filter.type) {
      case FilterType.timeRange:
        return _searchByTimeRange(filter.value);
      case FilterType.smartTag:
        return _searchBySmartTag(filter.value);
      case FilterType.album:
        return _searchByAlbum(filter.value);
      case FilterType.imageName:
        return _searchByImageName(filter.value);
      case FilterType.people:
        return _searchByPerson(filter.value);
      case FilterType.textRetrieve:
        return []; // Logic sẽ được triển khai sau
      default:
        return [];
    }
  }

  // Kiểm tra xem có filter nào khớp 100% với văn bản không
  bool hasExactMatch(String text) {
    if (text.isEmpty) return false;

    for (var category in filterCategories) {
      // Bỏ qua TextRetrieve
      if (category.type == FilterType.textRetrieve) continue;

      for (var option in category.options) {
        if (option.toLowerCase() == text.toLowerCase()) {
          return true;
        }
      }
    }

    return false;
  }

  // Danh sách các loại filter
  final List<FilterCategory> filterCategories = [
    FilterCategory(
      type: FilterType.timeRange,
      icon: Icons.calendar_today_outlined,
      label: 'Time Range',
      options: timeRangeOption,
    ),
    FilterCategory(
      type: FilterType.smartTag,
      icon: Icons.tag,
      label: 'Smart Tags',
      options: [],
    ),
    FilterCategory(
      type: FilterType.album,
      icon: Icons.photo_album_outlined,
      label: 'Album',
      options: [], // Sẽ được tự động điền từ _photoList
    ),
    FilterCategory(
      type: FilterType.imageName,
      icon: Icons.image,
      label: 'Image Name',
      options: [], // Sẽ được tự động điền từ _photoList
    ),
    FilterCategory(
      type: FilterType.people,
      icon: Icons.people,
      label: 'People',
      options: [], // Sẽ được tự động điền từ _photoList
    ),
    FilterCategory(
      type: FilterType.textRetrieve,
      icon: Icons.image_search,
      label: 'Text Retrieve',
      options: [],
    ),
  ];

  // Các hàm tìm kiếm cụ thể
  List<Photo> _searchByTimeRange(String timeRange) {
    DateTime now = DateTime.now();
    DateTime? startDate;
    DateTime endDate = now;
    bool isMonthFilter = false;
    int? specificMonth;

    switch (timeRange) {
      case 'Today':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'Yesterday':
        final yesterday = now.subtract(const Duration(days: 1));
        startDate = DateTime(yesterday.year, yesterday.month, yesterday.day);
        endDate = DateTime(
            yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
        break;
      case 'This Week':
        // Lấy ngày đầu tuần (thứ Hai)
        final weekday = now.weekday;
        startDate = now.subtract(Duration(days: weekday - 1));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        break;
      case 'Last Week':
        // Tuần trước: từ thứ Hai tuần trước đến Chủ nhật tuần trước
        final weekday = now.weekday;
        final lastWeekEnd = now.subtract(Duration(days: weekday));
        final lastWeekStart = lastWeekEnd.subtract(const Duration(days: 6));
        startDate = DateTime(
            lastWeekStart.year, lastWeekStart.month, lastWeekStart.day);
        endDate = DateTime(
            lastWeekEnd.year, lastWeekEnd.month, lastWeekEnd.day, 23, 59, 59);
        break;
      case 'Last 30 days':
        startDate = now.subtract(const Duration(days: 30));
        break;
      case 'This Month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'Last Month':
        // Tháng trước: từ ngày 1 tháng trước đến ngày cuối tháng trước
        if (now.month == 1) {
          // Nếu là tháng 1 thì tháng trước là tháng 12 năm trước
          startDate = DateTime(now.year - 1, 12, 1);
          endDate = DateTime(now.year, 1, 0, 23, 59,
              59); // Ngày 0 của tháng 1 = ngày cuối của tháng 12
        } else {
          startDate = DateTime(now.year, now.month - 1, 1);
          endDate = DateTime(now.year, now.month, 0, 23, 59,
              59); // Ngày 0 của tháng hiện tại = ngày cuối của tháng trước
        }
        break;
      case 'This Year':
        startDate = DateTime(now.year, 1, 1);
        break;
      case 'Last Year':
        startDate = DateTime(now.year - 1, 1, 1);
        endDate = DateTime(now.year - 1, 12, 31, 23, 59, 59);
        break;
      default:
        // Xử lý các tháng từ January đến December
        final monthNames = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December'
        ];

        final monthIndex = monthNames.indexOf(timeRange);
        if (monthIndex != -1) {
          // Cách hiệu quả: đánh dấu là tìm kiếm theo tháng cụ thể
          isMonthFilter = true;
          specificMonth =
              monthIndex + 1; // +1 vì tháng trong DateTime bắt đầu từ 1
        } else {
          return [];
        }
    }

    return _photoList.where((photo) {
      // Sử dụng createdAt thay vì dateTime
      final photoDate = photo.createdAt;
      if (photoDate == null) return false;

      if (isMonthFilter && specificMonth != null) {
        // Với filter tháng: chỉ quan tâm đến tháng, không quan tâm năm
        return photoDate.month == specificMonth;
      } else if (startDate != null) {
        // Với các filter khác: kiểm tra nằm trong khoảng thời gian
        return photoDate.isAfter(startDate) && photoDate.isBefore(endDate);
      }
      return false;
    }).toList();
  }

  List<Photo> _searchBySmartTag(String tag) {
    final results = _photoList.where((photo) {
      return (photo.labels.labels.locationLabels.isNotEmpty &&
              photo.labels.labels.locationLabels[0].label == tag) ||
          (photo.labels.labels.eventLabels.isNotEmpty &&
              photo.labels.labels.eventLabels[0].label == tag) ||
          (photo.labels.labels.actionLabels.isNotEmpty &&
              photo.labels.labels.actionLabels[0].label == tag);
    }).toList();
    return results;
  }

  List<Photo> _searchByAlbum(String albumName) {
    return _albumList
        .where((album) => album.name == albumName)
        .first
        .imageList
        .toList();
  }

  List<Photo> _searchByImageName(String name) {
    return [];
    // return _photoList.where((photo) =>
    //   photo.name.toLowerCase().contains(name.toLowerCase())
    // ).toList();
  }

  List<Photo> _searchByPerson(String personName) {
    return _personGroupList
        .where((person) => person.name == personName)
        .first
        .faces
        .map((face) => Photo(
            id: face.imageId,
            imageUrl: face.imageUrl,
            uploaderId: 'temp_uploader_id',
            imageBucketId: face.imageBucketId,
            imageName: face.imageName,
            labels: face.imageLabel))
        .toList();
  }

  // Điền các tùy chọn từ danh sách ảnh
  void _populateFilterOptions() {
    // add option -> filter.album
    final Set<String> albums = {};
    for (var album in _albumList) {
      if (album.name.isNotEmpty) {
        albums.add(album.name);
      }
    }

    // add option -> filter.people
    final Set<String> people = {};
    for (var person in _personGroupList) {
      if (person.name.isNotEmpty) {
        people.add(person.name);
      }
    }

    // add option -> filter.smartTag
    final smartTags = getAllSmartTag();

    // TODO: add implement here
    // NOTE: AFTER ADD CAPTION TO IMAGE
    // add option -> filter.imageName
    // final Set<String> imageNames = {};
    // for (var photo in _photoList) {
    //   if (photo.name.isNotEmpty) {
    //     imageNames.add(photo.name);
    //   }
    // }

    // Cập nhật danh sách filterCategories
    for (var i = 0; i < filterCategories.length; i++) {
      if (filterCategories[i].type == FilterType.album) {
        filterCategories[i] = FilterCategory(
          type: FilterType.album,
          icon: Icons.photo_album,
          label: 'Album',
          options: albums.toList(),
        );
      } else if (filterCategories[i].type == FilterType.smartTag) {
        filterCategories[i] = FilterCategory(
          type: FilterType.smartTag,
          icon: Icons.tag,
          label: 'Smart Tags',
          options: smartTags,
        );
      } else if (filterCategories[i].type == FilterType.people) {
        filterCategories[i] = FilterCategory(
          type: FilterType.people,
          icon: Icons.people,
          label: 'People',
          options: people.toList(),
        );
      }
      // else if (filterCategories[i].type == FilterType.imageName) {
      //   filterCategories[i] = FilterCategory(
      //     type: FilterType.imageName,
      //     icon: Icons.image,
      //     label: 'Image Name',
      //     options: imageNames.toList(),
      //   );
    }
  }

  // Lấy filter hiện tại
  FilterOption? getSelectedFilter() => _selectedFilter;

  // Chọn một filter và áp dụng tìm kiếm
  void selectFilter(FilterOption filter) {
    _selectedFilter = filter;

    // Thực hiện tìm kiếm dựa trên bộ lọc đã chọn
    if (filter.type == FilterType.textRetrieve) {
      // Để trống logic cho TextRetrieve - sẽ được triển khai sau
      _searchResults = [];
    } else {
      _searchResults = _searchPhotos(filter);
    }

    notifyListeners();
  }

  // Xóa filter hiện tại
  void clearFilter() {
    _selectedFilter = null;
    _searchResults = [];
    notifyListeners();
  }

  // Bật/tắt tìm kiếm bằng giọng nói
  void toggleVoiceSearch() {
    _isVoiceSearchOn = !_isVoiceSearchOn;
    notifyListeners();
  }
}
