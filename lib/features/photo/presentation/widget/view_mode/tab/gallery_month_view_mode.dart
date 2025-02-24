import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/widget/view_mode/components/photo_month_view.dart';
import 'package:intl/intl.dart';

class GalleryMonthViewMode extends StatelessWidget {
  const GalleryMonthViewMode({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoBloc, PhotoState>(
      key: PageStorageKey('monthViewMode'),
      builder: (context, state) {
        if (state is! PhotoFetchSuccess) {
          return Center(
            child: Text('Something wrong happended !'),
          );
        }

        return CustomScrollView(
          // key: PageStorageKey('monthView'),
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
              var section = state.groupedByMonth[index];
              var sectionYear = section['year'];
              List<dynamic> sectionMonth = section['group'];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 16)
                      ..copyWith(bottom: 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sectionYear.toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10),
                      StaggeredGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        children: List.generate(
                          sectionMonth.length,
                          (index) {
                            var group = sectionMonth[index];
                            return PhotoMonthView(
                              month: group['month'],
                              date: DateTime(
                                sectionYear,
                                DateFormat.MMM().parse(group['month']).month,
                              ),
                              coverImageUrl:
                                  (group['images'] as List<Photo>)[0].imageUrl!,
                              images: group['images'],
                            );
                          },
                        ),
                      ),
                    ]),
              );
            }, childCount: state.groupedByMonth.length)),
          ],
        );
      },
    );
  }
}
