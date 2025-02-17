import 'package:flutter/material.dart';

// Updated Destination class with separate icons for normal and selected states.
class Destination {
  final String label;
  final IconData icon; // Outline icon (not selected)
  final IconData selectedIcon; // Filled icon (selected)

  const Destination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}

const destinations = [
  Destination(
    label: "Photo",
    icon: Icons.photo_outlined,
    selectedIcon: Icons.photo,
  ),
  Destination(
    label: "Album",
    icon: Icons.collections_bookmark_outlined,
    selectedIcon: Icons.collections_bookmark,
  ),
  Destination(
    label: "Explore",
    icon: Icons.explore_outlined,
    selectedIcon: Icons.explore,
  ),
  Destination(
    label: "Search",
    icon: Icons.search_outlined,
    selectedIcon: Icons.search,
  ),
];
