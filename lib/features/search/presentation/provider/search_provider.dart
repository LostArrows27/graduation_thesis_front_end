import 'dart:math';
import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/common/service/speech_recognition_service.dart';
import 'package:graduation_thesis_front_end/features/album/domain/entities/album.dart';
import 'package:graduation_thesis_front_end/features/search/domain/entities/filter.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/person_group.dart';
import 'package:graduation_thesis_front_end/features/search/presentation/bloc/search_history/search_history_bloc.dart';
// import 'package:provider/provider.dart';
// import 'package:get_it/get_it.dart';

class SearchProvider extends ChangeNotifier {
  // State
  final List<Photo> _photoList;
  final List<Album> _albumList;
  final List<PersonGroup> _personGroupList;
  final SearchHistoryBloc _searchHistoryBloc;
  final SpeechRecognitionService _speechService = SpeechRecognitionService();

  bool _isVoiceSearchOn = false;
  List<Photo> _searchResults = [];
  FilterOption? _selectedFilter;

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
    required SearchHistoryBloc searchHistoryBloc,
  })  : _photoList = photoList,
        _albumList = albumList,
        _personGroupList = personGroupList,
        _searchHistoryBloc = searchHistoryBloc {
    _populateFilterOptions();
  }

  // Getter
  FilterOption? get selectedFilter => _selectedFilter;
  List<Photo> get allPhotos => _photoList;
  List<Photo> get searchResults => _searchResults;
  bool get isVoiceSearchOn => _isVoiceSearchOn;

  // utils
  // set search result
  void setSearchResults(List<Photo> photos) {
    _searchResults = photos;
    notifyListeners();
  }

  // get 2 random time range filter with 1 random photo in that time range-> give back {timeRange, timerange}
  List<Map<String, dynamic>> getRandomTimeRangeFilter() {
    final shuffledTimeRanges = List<String>.from(timeRangeOption)..shuffle();

    final List<Map<String, dynamic>> filtersWithPhotos = [];

    for (var filter in shuffledTimeRanges) {
      final photos = _searchByTimeRange(filter);
      if (photos.isNotEmpty) {
        final random = Random();
        final randomIndex = random.nextInt(photos.length);
        filtersWithPhotos
            .add({'filter': filter, 'url': photos[randomIndex].imageUrl ?? ''});

        if (filtersWithPhotos.length == 2) break;
      }
    }

    while (filtersWithPhotos.length < 2) {
      filtersWithPhotos.add({'filter': 'This Month', 'url': ''});
    }

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
        // Take the first day of the week
        final weekday = now.weekday;
        startDate = now.subtract(Duration(days: weekday - 1));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        break;
      case 'Last Week':
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
        if (now.month == 1) {
          startDate = DateTime(now.year - 1, 12, 1);
          endDate = DateTime(now.year, 1, 0, 23, 59, 59);
        } else {
          startDate = DateTime(now.year, now.month - 1, 1);
          endDate = DateTime(now.year, now.month, 0, 23, 59, 59);
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
          isMonthFilter = true;
          specificMonth = monthIndex + 1;
        } else {
          return [];
        }
    }

    return _photoList.where((photo) {
      final photoDate = photo.createdAt;
      if (photoDate == null) return false;

      if (isMonthFilter && specificMonth != null) {
        return photoDate.month == specificMonth;
      } else if (startDate != null) {
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
  return _photoList
        .where((photo) => (photo.caption != null &&
                photo.caption!.toLowerCase().contains(name.toLowerCase()) ||
            photo.imageName.toLowerCase().contains(name.toLowerCase())))
        .toList();
  }

  List<Photo> _searchByPerson(String personName) {
    final personGroup =
        _personGroupList.where((person) => person.name == personName).first;

    final Set<String> personImageIds =
        personGroup.faces.map((face) => face.imageId).toSet();

    final List<Photo> matchingPhotos =
        _photoList.where((photo) => personImageIds.contains(photo.id)).toList();

    matchingPhotos.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    return matchingPhotos;
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

    // add option -> filter.imageName
    final Set<String> imageNames = {};
    for (var photo in _photoList) {
      if (photo.caption != null && photo.caption!.isNotEmpty) {
        imageNames.add(photo.caption!);
      }
    }

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
      } else if (filterCategories[i].type == FilterType.imageName) {
        filterCategories[i] = FilterCategory(
          type: FilterType.imageName,
          icon: Icons.text_fields,
          label: 'Image Name',
          options: imageNames.toList(),
        );
      }
    }
  }

  // Lấy filter hiện tại
  FilterOption? getSelectedFilter() => _selectedFilter;

  // Chọn một filter và áp dụng tìm kiếm
  void selectFilter(FilterOption filter) {
    _selectedFilter = filter;

    if (filter.type == FilterType.textRetrieve) {
      _searchHistoryBloc.add(QueryImageByTextEvent(query: filter.value));
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

// Replace the existing toggleVoiceSearch method with this
  Future<void> toggleVoiceSearch({Function(String)? onTextRecognized}) async {
    if (_speechService.isListening) {
      await _speechService.stopListening();
      _isVoiceSearchOn = false;
    } else {
      bool available = await _speechService.initialize();
      if (available) {
        _isVoiceSearchOn =
            await _speechService.startListening(onResult: (text) {
          if (text.isNotEmpty && onTextRecognized != null) {
            onTextRecognized(text);
          }
          _isVoiceSearchOn = false;
          notifyListeners();
        });
      }
    }
    notifyListeners();
  }

// Add method to stop listening
  Future<void> stopVoiceSearch() async {
    if (_speechService.isListening) {
      await _speechService.stopListening();
      _isVoiceSearchOn = false;
      notifyListeners();
    }
  }
}
