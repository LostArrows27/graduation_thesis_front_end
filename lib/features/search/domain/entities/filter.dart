import 'package:flutter/material.dart';

enum FilterType { timeRange, smartTag, album, imageName, people, textRetrieve }

class FilterCategory {
  final FilterType type;
  final IconData icon;
  final String label;
  final List<String> options;

  FilterCategory({
    required this.type,
    required this.icon,
    required this.label,
    required this.options,
  });
}

class FilterOption {
  final FilterType type;
  final String value;
  final String categoryName;
  final IconData categoryIcon;

  FilterOption({
    required this.type,
    required this.value,
    required this.categoryName,
    required this.categoryIcon,
  });
}