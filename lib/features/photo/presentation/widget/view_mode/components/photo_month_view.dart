import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/group_album_image.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/hero_network_image.dart';
import 'package:intl/intl.dart';

class PhotoMonthView extends StatelessWidget {
  final String month;
  final String coverImageUrl;
  final List<Photo> images;
  final DateTime date;

  static const String heroTag = 'month_view_mode_tags';

  const PhotoMonthView(
      {super.key,
      required this.month,
      required this.coverImageUrl,
      required this.date,
      required this.images});

  void _onMonthTap(BuildContext context) {
    final albumFolder = groupImagePhotoByDate(images);
    final title = DateFormat('MMMM yyyy').format(date);
    final itemCount = images.length;

    context.push(Routes.albumViewerPage, extra: {
      'title': title,
      'totalItem': itemCount,
      'albumFolders': albumFolder,
      'heroTag': heroTag,
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _onMonthTap(context);
      },
      child: Stack(
        children: [
          Container(
              height: 270,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: HeroNetworkImage(
                  borderRadius: 15,
                  imageUrl: coverImageUrl,
                  heroTag: coverImageUrl + heroTag)),
          Positioned.fill(
              child: Container(
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        month,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Material(
                          color: Colors.white24,
                          child: InkWell(
                            onTap: () {
                              _onMonthTap(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 11,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 4),
                  Text('${images.length.toString()} photos',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Colors.white70))
                ],
              ),
            ),
          ))
        ],
      ),
    );

    // return Hero(
    //   tag: coverImageUrl,
    //   child: CachedNetworkImage(
    //     imageUrl: coverImageUrl,
    //     imageBuilder: (context, imageProvider) => GestureDetector(
    //       onTap: () {
    //         _onMonthTap(context);
    //       },
    //       child: Container(
    //         height: 270,
    //         decoration: BoxDecoration(
    //             color: Colors.black,
    //             borderRadius: BorderRadius.circular(8),
    //             image: DecorationImage(
    //                 opacity: 0.8, image: imageProvider, fit: BoxFit.cover)),
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Row(
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   Text(
    //                     month,
    //                     style: TextStyle(
    //                         fontSize: 24,
    //                         fontWeight: FontWeight.w600,
    //                         color: Colors.white),
    //                   ),
    //                   SizedBox(width: 10),
    //                   ClipRRect(
    //                     borderRadius: BorderRadius.circular(40),
    //                     child: Material(
    //                       color: Colors.white24,
    //                       child: InkWell(
    //                         onTap: () {
    //                           _onMonthTap(context);
    //                         },
    //                         child: Padding(
    //                           padding: EdgeInsets.all(6),
    //                           child: Icon(
    //                             Icons.arrow_forward_ios,
    //                             color: Colors.white,
    //                             size: 11,
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   )
    //                 ],
    //               ),
    //               SizedBox(height: 4),
    //               Text('${images.length.toString()} photos',
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.w500,
    //                       fontSize: 12,
    //                       color: Colors.white70))
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //     placeholder: (context, url) => Container(
    //       height: 270,
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(8),
    //         color: Theme.of(context).colorScheme.surfaceDim,
    //       ),
    //     ),
    //     errorWidget: (context, url, error) => Container(
    //       height: 270,
    //       decoration: BoxDecoration(
    //           color: Theme.of(context).colorScheme.outline,
    //           borderRadius: BorderRadius.circular(8)),
    //       child: Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Row(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 Text(
    //                   month,
    //                   style: TextStyle(
    //                       fontSize: 24,
    //                       fontWeight: FontWeight.w600,
    //                       color: Colors.white),
    //                 ),
    //                 SizedBox(width: 10),
    //                 ClipRRect(
    //                   borderRadius: BorderRadius.circular(40),
    //                   child: Material(
    //                     color: Colors.white24,
    //                     child: InkWell(
    //                       onTap: () {
    //                         _onMonthTap(context);
    //                       },
    //                       child: Padding(
    //                         padding: EdgeInsets.all(6),
    //                         child: Icon(
    //                           Icons.arrow_forward_ios,
    //                           color: Colors.white,
    //                           size: 11,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 )
    //               ],
    //             ),
    //             SizedBox(height: 4),
    //             Text('${images.length.toString()} photos',
    //                 style: TextStyle(
    //                     fontWeight: FontWeight.w500,
    //                     fontSize: 12,
    //                     color: Colors.white70))
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
