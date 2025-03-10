import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/widgets/album_image_select_item.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/widgets/open_choose_image_album_modal.dart';
import 'package:provider/provider.dart';

class AlbumImageBrowser extends StatefulWidget {
  final ScrollController scrollController;

  const AlbumImageBrowser({
    super.key,
    required this.scrollController,
  });

  @override
  State<AlbumImageBrowser> createState() => _AlbumImageBrowserState();
}

class _AlbumImageBrowserState extends State<AlbumImageBrowser> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chooseAlbumImageModel = Provider.of<ChooseAlbumImageModel>(context);
    final photos = chooseAlbumImageModel.getProviderImages;

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
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];

                return AlbumImageSelectItem(
                    photo: photo,
                    addImage: chooseAlbumImageModel.addImage,
                    removeImage: chooseAlbumImageModel.removeImage,
                    isSelected: chooseAlbumImageModel.selectedImages
                        .any((image) => image.id == photo.id));
              },
            ),
          ),
        ],
      ),
    );
  }
}
