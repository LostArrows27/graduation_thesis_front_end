import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/convert_axis_cell_count.dart';
import 'package:graduation_thesis_front_end/core/utils/group_album_image.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/entities/album_folder.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/widget/hero_network_image.dart';

class AlbumViewerPage extends StatelessWidget {
  final String title;
  final int totalItem;
  final List<AlbumFolder> albumFolders;

  const AlbumViewerPage({
    super.key,
    required this.title,
    required this.totalItem,
    required this.albumFolders,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 5),
            Text(
              '$totalItem photos',
              style: TextStyle(
                  fontSize: 14, color: Theme.of(context).colorScheme.outline),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final folderTitle = albumFolders[index].title;
                  final photoList = albumFolders[index].photos;

                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          folderTitle,
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.outline),
                        ),
                        SizedBox(height: 20),
                        StaggeredGrid.count(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          children: [
                            ...photoList.asMap().map((index, photo) {
                              final [crossAxisCount, mainAxisCount] =
                                  convertAxisCellCount(index, photoList.length);
                              return MapEntry(
                                index,
                                StaggeredGridTile.count(
                                    crossAxisCellCount: crossAxisCount,
                                    mainAxisCellCount: mainAxisCount,
                                    child: GestureDetector(
                                      onTap: () {
                                        context.push(Routes.imageSliderPage,
                                            extra: {
                                              'url': photo.imageUrl,
                                              'images':
                                                  getAllPhotoFromGroupImage(
                                                      albumFolders),
                                            });
                                      },
                                      child: HeroNetworkImage(
                                          borderRadius: 15,
                                          imageUrl: photo.imageUrl!,
                                          heroTag: photo.imageUrl ?? ''),
                                    )),
                              );
                            }).values
                          ],
                        )
                      ],
                    ),
                  );
                },
                itemCount: albumFolders.length)
          ],
        ),
      ),
    );
  }
}
