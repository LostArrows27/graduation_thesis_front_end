import 'package:flutter/material.dart';

Widget textIcon(IconData icon, String text, VoidCallback onPressed,
    [bool isDark = false, bool isFavorite = false]) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(30),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 60,
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Column(
              children: [
                Icon(icon,
                    color: isFavorite && !isDark
                        ? Colors.red.shade400
                        : isFavorite && isDark
                            ? Colors.redAccent.shade700
                            : isDark
                                ? Colors.black
                                : Colors.white,
                    size: 22),
                SizedBox(height: 4),
                Text(
                  text,
                  style: TextStyle(
                      color: isDark ? Colors.black : Colors.white,
                      fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
