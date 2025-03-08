import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/pick_image.dart';
import 'package:image_picker/image_picker.dart';

void showAddModal(BuildContext context) {
  const modalHeightSize = 0.9;
  const modalMaxHeightSize = 0.9;

  void onTakePhotoAndUpload() async {
    final cameraFile = await selectLibraryImage(ImageSource.camera, context);

    if (cameraFile == null) return;

    // ignore: use_build_context_synchronously
    context.push(Routes.uploadPhotoPage, extra: [cameraFile]);
  }

  void onChooseGalleryImageAndUpload() async {
    final galleryFiles = await pickMultiImagesFile();

    if (galleryFiles.isEmpty) return;

    // ignore: use_build_context_synchronously
    context.push(Routes.uploadPhotoPage, extra: galleryFiles);
  }

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
          initialChildSize: modalHeightSize,
          minChildSize: modalHeightSize,
          maxChildSize: modalMaxHeightSize,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    width: double.infinity,
                    height:
                        MediaQuery.of(context).size.height * modalHeightSize,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Text(
                            'Create new',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        _buildListTile(
                            context, Icons.photo_album_outlined, "Album"),
                        _buildListTile(
                          context,
                          Icons.movie_creation_outlined,
                          "Recap Video",
                          onTap: () {
                            Navigator.pop(context);
                            context.push(Routes.videoRenderStatusPage);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Text(
                            'Upload photos',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        _buildListTile(
                            context, Icons.camera_alt_outlined, "Take a photo",
                            onTap: onTakePhotoAndUpload),
                        _buildListTile(context, Icons.phone_android_outlined,
                            "Upload from your devices",
                            onTap: onChooseGalleryImageAndUpload),
                        _buildListTile(
                            context, Icons.share, "Share with a partner"),
                      ],
                    ),
                  )
                ],
              ),
            );
          });
    },
  );
}

Widget _buildListTile(BuildContext context, IconData icon, String title,
    {Function()? onTap}) {
  return SizedBox(
      height: 56,
      width: MediaQuery.of(context).size.width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // ignore: deprecated_member_use
          splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.13),
          onTap: () {
            if (onTap != null) {
              onTap();
            }
          },
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 24,
                  ),
                  SizedBox(width: 30),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
}
