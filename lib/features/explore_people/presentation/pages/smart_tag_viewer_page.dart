import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/enum/app_enum.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/cached_image.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/failure.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/loader.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/group_album_image.dart';
import 'package:graduation_thesis_front_end/core/utils/group_image_by_label.dart';
import 'package:graduation_thesis_front_end/core/utils/string_captialize.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/entities/album_folder.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';

class SmartTagViewerPage extends StatelessWidget {
  final SmartTagsType type;

  const SmartTagViewerPage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '${captializeString(type.name)} tags',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: BlocBuilder<PhotoBloc, PhotoState>(
        builder: (context, state) {
          if (state is PhotoFetchLoading || state is PhotoInitial) {
            return Loader();
          }

          if (state is PhotoFetchFailure) {
            return FailureWidget(message: 'Failed to fetch photo data');
          }

          List<AlbumFolder> albumFolder =
              groupImageByLabel((state as PhotoFetchSuccess).photos, type);

          return Padding(
              padding: EdgeInsets.all(20),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 30,
                    childAspectRatio: 0.69,
                  ),
                  itemCount: albumFolder.length,
                  itemBuilder: (context, index) {
                    var imageUrl = albumFolder[index]
                        .photos[
                            Random().nextInt(albumFolder[index].photos.length)]
                        .imageUrl!;

                    return GestureDetector(
                      onTap: () {
                        context.push(Routes.albumViewerPage, extra: {
                          'title': captializeString(albumFolder[index].title),
                          'totalItem': albumFolder[index].photos.length,
                          'albumFolders':
                              groupImagePhotoByDate(albumFolder[index].photos)
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 110,
                            height: 110,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedImage(imageUrl: imageUrl),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            captializeString(albumFolder[index].title),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '${albumFolder[index].photos.length}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    );
                  }));
        },
      ),
    );
  }
}
