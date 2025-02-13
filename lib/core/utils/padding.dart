import 'package:flutter/material.dart';

class PaddingUtils {
  static EdgeInsets pad(double leftRight, double topBottom) {
    return EdgeInsets.fromLTRB(leftRight, topBottom, leftRight, topBottom);
  }
}
