import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/cached_image.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/selected_image.dart';

class OnlineImageSelectItem extends StatelessWidget {
  final SelectedImage image;
  final bool isSelected;
  final Function(SelectedImage image) addImage;
  final Function(String imageUrl) removeImage;
  const OnlineImageSelectItem(
      {super.key,
      required this.image,
      required this.isSelected,
      required this.addImage,
      required this.removeImage});

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      // CachedNetworkImage(
      //   imageUrl: image.filePath,
      //   fit: BoxFit.cover,
      //   placeholder: (context, url) => Container(
      //     color: Theme.of(context).colorScheme.surfaceDim,
      //   ),
      //   errorWidget: (context, url, error) => Container(
      //     color: Theme.of(context).colorScheme.surfaceDim,
      //     child: Icon(
      //       Icons.error,
      //       color: Theme.of(context).colorScheme.error,
      //     ),
      //   ),
      // ),
      CachedImage(imageUrl: image.filePath),
      Positioned.fill(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.black12,
            onTap: () {
              final selectImage = SelectedImage(
                  filePath: image.filePath, source: Source.online);
              isSelected ? removeImage(image.filePath) : addImage(selectImage);
            },
          ),
        ),
      ),
      Positioned(
          left: 9,
          top: 9,
          child: isSelected
              ? Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipOval(
                      child: Container(
                        width: 20,
                        height: 20,
                        color: Colors.white,
                      ),
                    ),
                    Positioned.fill(
                        top: -2.5,
                        left: -2.5,
                        child: Icon(Icons.check_circle_rounded,
                            size: 25,
                            color:
                                Theme.of(context).colorScheme.inversePrimary))
                  ],
                )
              : Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipOval(
                      child: Container(
                        width: 20,
                        height: 20,
                        color: Colors.transparent,
                      ),
                    ),
                    Positioned.fill(
                        top: -2.5,
                        left: -2.5,
                        child: Icon(
                          Icons.circle_outlined,
                          size: 25,
                          color: Colors.white,
                        ))
                  ],
                ))
    ]);
  }
}
