import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/cached_image.dart';

class AlbumImageSelectItem extends StatelessWidget {
  final Photo photo;
  final bool isSelected;
  final Function(Photo image) addImage;
  final Function(String imageId) removeImage;
  const AlbumImageSelectItem(
      {super.key,
      required this.photo,
      required this.isSelected,
      required this.addImage,
      required this.removeImage});

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      CachedImage(imageUrl: photo.imageUrl!),
      Positioned.fill(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.black12,
            onTap: () {
              isSelected ? removeImage(photo.id) : addImage(photo);
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
