import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/face.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/widgets/cropped_image.dart';

Widget buildFaceImage(Face face) {
  final [top, right, bottom, left] =
      face.coordinate.map((e) => e.toDouble()).toList();

  return CroppedImageWidget(
      imageUrl: face.imageUrl,
      boundingBox: Rect.fromLTRB(left, top, right, bottom));
}
