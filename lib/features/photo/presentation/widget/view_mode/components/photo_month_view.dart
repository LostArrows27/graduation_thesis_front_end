import 'package:cached_network_image/cached_network_image.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';

class PhotoMonthView extends StatelessWidget {
  final String month;
  final String coverImageUrl;
  final List<Photo> images;
  final DateTime date;
  final bool isCrab;

  const PhotoMonthView(
      {super.key,
      required this.month,
      required this.coverImageUrl,
      required this.date,
      this.isCrab = false,
      required this.images});

  void _onMonthTap() {
    // TODO: redirect to album month view
  }

  @override
  Widget build(BuildContext context) {
    return Crab(
      tag: "PLEASE FIX ME LATER LIL BRO 😭",
      child: CachedNetworkImage(
        imageUrl: coverImageUrl,
        imageBuilder: (context, imageProvider) => Container(
          height: 270,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                  opacity: 0.8, image: imageProvider, fit: BoxFit.cover)),
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
                            _onMonthTap();
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
        ),
        placeholder: (context, url) => Container(
          height: 270,
          color: Theme.of(context).colorScheme.surfaceDim,
        ),
        errorWidget: (context, url, error) => Container(
          height: 270,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(8)),
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
                            _onMonthTap();
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
        ),
      ),
    );
  }
}
