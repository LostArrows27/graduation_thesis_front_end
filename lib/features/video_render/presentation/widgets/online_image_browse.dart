import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/selected_image.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/pages/video_image_picker_page.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/widgets/online_image_select_item.dart';

class GallerySelectedImage extends SelectedImage {
  final bool isSelected;

  GallerySelectedImage(
      {required super.filePath,
      required super.source,
      required this.isSelected});
}

class OnlineImageBrowse extends StatefulWidget {
  final ScrollController scrollController;
  final List<Photo> photos;
  final ImageProviderModel imageProvider;

  const OnlineImageBrowse({
    super.key,
    required this.scrollController,
    required this.photos,
    required this.imageProvider,
  });

  @override
  State<OnlineImageBrowse> createState() => _OnlineImageBrowseState();
}

class _OnlineImageBrowseState extends State<OnlineImageBrowse> {
  final List<String> selectedImages = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedImages.addAll(widget.imageProvider.getImageList
          .where((element) => element.source == Source.online)
          .map((e) => e.filePath));
    });
  }

  void addImage(SelectedImage image) {
    setState(() {
      selectedImages.add(image.filePath);
    });
  }

  void removeImage(String imageUrl) {
    setState(() {
      selectedImages.remove(imageUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
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
              itemCount: widget.photos.length,
              itemBuilder: (context, index) {
                final photo = widget.photos[index];
                final selectPhoto = SelectedImage(
                    filePath: photo.imageUrl ?? '', source: Source.online);

                return OnlineImageSelectItem(
                    image: selectPhoto,
                    addImage: addImage,
                    removeImage: removeImage,
                    isSelected: selectedImages.contains(photo.imageUrl));
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
                        onPressed: selectedImages.isEmpty
                            ? null
                            : () {
                                List<SelectedImage> addImageLists =
                                    selectedImages
                                        .map((e) => SelectedImage(
                                            filePath: e, source: Source.online))
                                        .toList();

                                widget.imageProvider
                                    .changeOnlineImageList(addImageLists);

                                Navigator.pop(context);
                              },
                        child: Text(
                          selectedImages.isEmpty
                              ? 'Add'
                              : 'Add (${selectedImages.length})',
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
