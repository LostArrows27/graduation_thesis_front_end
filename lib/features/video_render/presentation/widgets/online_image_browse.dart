import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/core/utils/show_browse_online_gallery_modal.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/selected_image.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/pages/video_image_picker_page.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/widgets/online_image_select_item.dart';
import 'package:provider/provider.dart';

class GallerySelectedImage extends SelectedImage {
  final bool isSelected;

  GallerySelectedImage(
      {required super.filePath,
      required super.source,
      required this.isSelected});
}

class OnlineImageBrowse extends StatefulWidget {
  final ScrollController scrollController;
  final ImageProviderModel imageProvider;

  const OnlineImageBrowse({
    super.key,
    required this.scrollController,
    required this.imageProvider,
  });

  @override
  State<OnlineImageBrowse> createState() => _OnlineImageBrowseState();
}

class _OnlineImageBrowseState extends State<OnlineImageBrowse> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providedImage = Provider.of<ProviderImageModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (!_initialized) {
          providedImage.clearSelectedImages();
          providedImage.addAllImage(widget.imageProvider.getImageList
              .where((element) => element.source == Source.online)
              .map((e) => e.filePath)
              .toList());
          _initialized = true;
        }
      }
    });

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Recent'),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 390,
            child: GridView.builder(
              controller: widget.scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: providedImage.getProviderImages.length,
              itemBuilder: (context, index) {
                final photo = providedImage.getProviderImages[index];
                final selectPhoto = SelectedImage(
                    filePath: photo.imageUrl ?? '', source: Source.online);

                return OnlineImageSelectItem(
                    image: selectPhoto,
                    addImage: providedImage.addImage,
                    removeImage: providedImage.removeImage,
                    isSelected:
                        providedImage.selectedImages.contains(photo.imageUrl));
              },
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.transparent),
                      ),
                      icon: Icon(Icons.image),
                      onPressed: () {},
                      label: Text('View selected')),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiaryContainer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: providedImage.selectedImages.isEmpty
                            ? null
                            : () {
                                List<SelectedImage> addImageLists =
                                    providedImage.selectedImages
                                        .map((e) => SelectedImage(
                                            filePath: e, source: Source.online))
                                        .toList();

                                addImageLists.removeWhere((element) => widget
                                    .imageProvider.getImageList
                                    .contains(element));

                                widget.imageProvider
                                    .changeOnlineImageList(addImageLists);

                                Navigator.pop(context);
                              },
                        child: Text(
                          providedImage.selectedImages.isEmpty
                              ? 'Add'
                              : 'Add (${providedImage.selectedImages.length})',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onTertiaryContainer),
                        )),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
