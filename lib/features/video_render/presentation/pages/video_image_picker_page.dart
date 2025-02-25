import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/utils/pick_image.dart';
import 'package:graduation_thesis_front_end/core/utils/show_browse_online_gallery_modal.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/widgets/text_divider.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/selected_image.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/bloc/video_render_schema/video_render_schema_bloc.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/widgets/video_image_picker_bottom_bar.dart';
import 'package:graduation_thesis_front_end/init_dependencies.dart';

import 'package:provider/provider.dart';

class VideoImagePickerPage extends StatelessWidget {
  const VideoImagePickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<VideoRenderSchemaBloc>(),
      child: ChangeNotifierProvider(
        create: (context) => ImageProviderModel(),
        child: Consumer<ImageProviderModel>(
          builder: (context, imageProvider, _) => Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            "Choose Image For Your Recap Video",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 70),
                        GestureDetector(
                          onTap: () {
                            showBrowseOnlineGalleryModal(context);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 4,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_done_outlined,
                                  size: 45,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryFixed,
                                ),
                                SizedBox(height: 14),
                                Text(
                                  'Browse your online gallery',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryFixed,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        TextDivider(),
                        SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final imagePaths = await pickMultiImages();
                              final images = imagePaths
                                  .map((path) => SelectedImage(
                                      filePath: path, source: Source.offline))
                                  .toList();

                              imageProvider.addManyImages(images);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryFixedDim,
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            icon: Icon(
                              Icons.add_a_photo,
                              size: 22,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryFixedVariant,
                            ),
                            label: Text(
                              '  Upload From Your Device',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryFixedVariant,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar:
                VideoImagePickerBottomBar(imageProvider: imageProvider),
          ),
        ),
      ),
    );
  }
}

class ImageProviderModel extends ChangeNotifier {
  // NOTE: dat ten nham...
  final List<SelectedImage> imageList = [];

  List<SelectedImage> get getImageList => imageList;

  // Add a single image
  void addImage(SelectedImage image) {
    imageList.add(image);
    notifyListeners();
  }

  // Add multiple images
  void addManyImages(List<SelectedImage> images) {
    for (var image in images) {
      if (!imageList.any((element) => element.filePath == image.filePath)) {
        imageList.add(image);
      }
    }
    notifyListeners();
  }

  void changeOnlineImageList(List<SelectedImage> images) {
    imageList.removeWhere((element) => element.source == Source.online);
    imageList.addAll(images);
    notifyListeners();
  }

  // Remove an image
  void removeImage(String url) {
    imageList.removeWhere((element) => element.filePath == url);
    notifyListeners();
  }

  bool isImageSelected(String url) {
    return imageList.any((element) => element.filePath == url);
  }
}
