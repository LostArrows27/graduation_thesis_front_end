import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/hero_network_image.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';

class PhotoGrid extends StatelessWidget {
  final List<Photo> photos;

  const PhotoGrid({super.key, required this.photos});

  static String heroTag = 'search_photo_grid';

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return GestureDetector(
            onTap: () {
              context.push(Routes.imageSliderPage, extra: {
                'url': photo.imageUrl,
                'images': photos,
                'heroTag': heroTag,
              });
            },
            child: HeroNetworkImage(
                heroTag: photo.imageUrl! + heroTag, imageUrl: photo.imageUrl!));
      },
    );
  }
}
