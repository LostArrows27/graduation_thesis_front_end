import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/format_date.dart';
import 'package:graduation_thesis_front_end/core/utils/get_url_from_image_group.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/widget/hero_network_image.dart';

class GalleryAllViewMode extends StatefulWidget {
  const GalleryAllViewMode({super.key});

  @override
  State<GalleryAllViewMode> createState() => _GalleryAllViewModeState();
}

class _GalleryAllViewModeState extends State<GalleryAllViewMode>
    with SingleTickerProviderStateMixin {
  final Map<DateTime, String> formattedDatesCache = {};
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                                  child: GestureDetector(
                                    onTap: () {
                                      final photos = getPhotoFromImageGroup(
                                          state.groupedByDate);

                                      context
                                          .push(Routes.imageSliderPage, extra: {
                                        'url': image.imageUrl,
                                        'images': photos,
                                      });
                                    },
                                    child: HeroNetworkImage(
                                      imageUrl: image.imageUrl ?? '',
                                      heroTag: image.imageUrl ?? index,
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
