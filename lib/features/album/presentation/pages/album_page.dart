import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/cached_image.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/loader.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/group_album_image.dart';
import 'package:graduation_thesis_front_end/features/album/domain/entities/album.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/bloc/album_list/album_list_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  List<Album> recentAlbum = [];
  List<Album> otherAlbum = [];

  static const String heroTag = 'album_page_tags';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final albumState = context.read<AlbumListBloc>().state;
        if (albumState is! AlbumListLoaded) {
          context.read<AlbumListBloc>().add(GetAllAlbumEvent());
        } else {
          final tempAlbums = albumState.albums;

          setState(() {
            tempAlbums.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

            recentAlbum = tempAlbums.length > 4
                ? tempAlbums.sublist(0, 4)
                : List.from(tempAlbums);

            otherAlbum = tempAlbums.length > 4 ? tempAlbums.sublist(4) : [];
          });
        }
      }
    });
  }

  Widget _buildAlbumList(List<Album> albums) {
    return GridView.builder(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: albums.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
        ),
        itemBuilder: (context, index) {
          String coverUrl = albums[index].imageList[0].imageUrl!;

          return GestureDetector(
            onTap: () {
              context.push(Routes.albumViewerPage, extra: {
                'title': albums[index].name,
                'totalItem': albums[index].imageList.length,
                'albumFolders': groupImagePhotoByDate(albums[index].imageList),
                'heroTag': heroTag,
                'albumId': albums[index].id != 'favorite_album_id' &&
                        albums[index].id != 'profile_picture_album_id'
                    ? albums[index].id
                    : null,
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
              ),
              child: Stack(
                children: [
                  SizedBox.expand(
                    child: CachedImage(
                      borderRadius: 20,
                      imageUrl: coverUrl,
                    ),
                  ),
                  Positioned.fill(
                      child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(albums[index].name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                          SizedBox(height: 6),
                          Text('${albums[index].imageList.length} Photos',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoBloc, PhotoState>(
      builder: (context, photoState) {
        return BlocConsumer<AlbumListBloc, AlbumListState>(
          listener: (context, state) {
            if (state is AlbumListLoaded) {
              final tempAlbums = state.albums;

              setState(() {
                tempAlbums.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

                recentAlbum = tempAlbums.length > 4
                    ? tempAlbums.sublist(0, 4)
                    : List.from(tempAlbums);

                otherAlbum = tempAlbums.length > 4 ? tempAlbums.sublist(4) : [];
              });
            }
          },
          builder: (context, state) {
            if (state is AlbumListError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error happend. Pressed below button'),
                    SizedBox(height: 20),
                    FilledButton(
                      onPressed: () {
                        context.read<AlbumListBloc>().add(GetAllAlbumEvent());
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is AlbumListLoading) {
              return Loader();
            }

            if ((state as AlbumListLoaded).albums.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No album found'),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 120,
                      child: FilledButton(
                        onPressed: () {
                          context.read<AlbumListBloc>().add(GetAllAlbumEvent());
                        },
                        child: Text('Retry'),
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'Recently',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 20),
                        _buildAlbumList(recentAlbum),
                        SizedBox(height: 40),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: otherAlbum.isEmpty
                              ? []
                              : [
                                  Text(
                                    'Other album',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 20),
                                  _buildAlbumList(otherAlbum),
                                  SizedBox(height: 40),
                                ],
                        ),
                      ],
                    )));
          },
        );
      },
    );
  }
}
