import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/utils/format_date.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';

class GalleryAllViewMode extends StatefulWidget {
  const GalleryAllViewMode({super.key});

  @override
  State<GalleryAllViewMode> createState() => _GalleryAllViewModeState();
}

class _GalleryAllViewModeState extends State<GalleryAllViewMode> {
  final Map<DateTime, String> formattedDatesCache = {};

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PhotoBloc, PhotoState, PhotoFetchSuccess?>(
      selector: (state) {
        if (state is PhotoFetchSuccess) {
          return state;
        }
        return null;
      },
      builder: (context, state) {
        if (state == null) {
          return Center(child: Text('Something went wrong!'));
        }

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(top: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var section = state.groupedByDate[index];
                    DateTime sectionDate = section['date'];

                    String sectionTitle;
                    if (formattedDatesCache.containsKey(sectionDate)) {
                      sectionTitle = formattedDatesCache[sectionDate]!;
                    } else {
                      sectionTitle = formatDate(sectionDate);
                      formattedDatesCache[sectionDate] = sectionTitle;
                    }

                    List<Photo> imageLists =
                        List<Photo>.from(section['images']);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                            child: Text(
                              sectionTitle,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),
                          StaggeredGrid.count(
                            crossAxisCount: 4,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            children: imageLists.map((image) {
                              return Padding(
                                padding: const EdgeInsets.all(0),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: CachedNetworkImage(
                                    imageUrl: image.imageUrl ?? '',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceDim,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceDim,
                                      child: Icon(
                                        Icons.error,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: state.groupedByDate.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
