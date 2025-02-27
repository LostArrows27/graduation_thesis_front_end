import 'package:graduation_thesis_front_end/core/common/enum/app_enum.dart';

Season seasonFromString(String seasonString) {
  return Season.values.firstWhere(
      (e) => e.toString().split('.').last == seasonString.toLowerCase(),
      orElse: () => Season.spring);
}
