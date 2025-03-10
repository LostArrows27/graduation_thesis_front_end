import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/group_album_image.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/widget/hero_network_image.dart';

class GalleryYearViewMode extends StatelessWidget {
  const GalleryYearViewMode({super.key});

  void _onYearAlbumView(
      BuildContext context, List<Photo> imageLists, String yearName) {
    final title = '$yearName Review';
    final itemCount = imageLists.length;
    final yearAlbumFolder = groupImageByMonthAndWeek(imageLists);

    context.push(Routes.yearAlbumViewerPage, extra: {
      'title': title,
      'totalItem': itemCount,
      'yearAlbumFolders': yearAlbumFolder
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoBloc, PhotoState>(
      key: PageStorageKey('yearViewMode'),
      builder: (context, state) {
        if (state is! PhotoFetchSuccess) {
          return Center(
            child: Text('Something wrong happended !'),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
              var section = state.groupedByYear[index];
              var sectionYear = section['year'].toString();
              var imageLists = section['images'] as List<Photo>;

              return GestureDetector(
                  onTap: () {
                    _onYearAlbumView(context, imageLists, sectionYear);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Stack(
                      children: [
                        Container(
                          height: 550,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: HeroNetworkImage(
                              borderRadius: 24,
                              imageUrl: imageLists[0].imageUrl!,
                              heroTag: imageLists[0].imageUrl!),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: Colors.black26),
                            child: Padding(
                              padding: EdgeInsets.all(30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        sectionYear,
                                        style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                      SizedBox(width: 12),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: Material(
                                          color: Colors.white24,
                                          child: InkWell(
                                            onTap: () {},
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  Text('${imageLists.length.toString()} photos',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Colors.white70))
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ));

              // return GestureDetector(
              //   onTap: () {
              //     // TODO: navigate to year album ~
              //   },
              //   child: Padding(
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 30, vertical: 10),
              //       child: Container(
              //         height: 550,
              //         decoration: BoxDecoration(
              //           color: Colors.black87,
              //           borderRadius: BorderRadius.circular(24),
              //           image: DecorationImage(
              //             image: CachedNetworkImageProvider(
              //                 imageLists[0].imageUrl!),
              //             opacity: 0.8,
              //             fit: BoxFit.cover,
              //           ),
              //         ),
              //         child: Padding(
              //           padding: EdgeInsets.all(30),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Row(
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 children: [
              //                   Text(
              //                     sectionYear,
              //                     style: TextStyle(
              //                         fontSize: 32,
              //                         fontWeight: FontWeight.w600,
              //                         color: Colors.white),
              //                   ),
              //                   SizedBox(width: 12),
              //                   ClipRRect(
              //                     borderRadius: BorderRadius.circular(40),
              //                     child: Material(
              //                       color: Colors.white24,
              //                       child: InkWell(
              //                         onTap: () {},
              //                         child: Padding(
              //                           padding: EdgeInsets.all(10),
              //                           child: Icon(
              //                             Icons.arrow_forward_ios,
              //                             color: Colors.white,
              //                             size: 14,
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                   )
              //                 ],
              //               ),
              //               SizedBox(height: 6),
              //               Text('${imageLists.length.toString()} photos',
              //                   style: TextStyle(
              //                       fontWeight: FontWeight.w500,
              //                       fontSize: 14,
              //                       color: Colors.white70))
              //             ],
              //           ),
              //         ),
              //       )),
              // );
            }, childCount: state.groupedByYear.length)),
            SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        );
      },
    );
  }
}
