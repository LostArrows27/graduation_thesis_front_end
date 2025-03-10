import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/person_group.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/widgets/cropped_image.dart';

Widget imageTitle(PersonGroup? personGroup, BuildContext context) {
  if (personGroup == null ||
      personGroup.faces.isEmpty ||
      personGroup.faces[0].imageUrl.isEmpty) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
    ));
  } else {
    final [top, right, bottom, left] =
        personGroup.faces[0].coordinate.map((e) => e.toDouble()).toList();
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CroppedImageWidget(
              imageUrl: personGroup.faces[0].imageUrl,
              boundingBox: Rect.fromLTRB(left, top, right, bottom))),
    ));
  }
}
