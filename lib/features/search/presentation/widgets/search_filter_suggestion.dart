import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/cached_image.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/get_color_scheme.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/widgets/cropped_image.dart';
import 'package:graduation_thesis_front_end/features/search/domain/entities/filter.dart';
import 'package:graduation_thesis_front_end/features/search/presentation/bloc/bloc/search_history_listen_bloc.dart';
import 'package:graduation_thesis_front_end/features/search/presentation/provider/search_provider.dart';
import 'package:provider/provider.dart';

class SearchFilterSuggestions {
  // NOTE: build search suggest results -> user tap -> redirect to that page
  static Widget buildSearchSuggestResults(BuildContext context,
      SearchController controller, SearchHistoryListenBloc searchBloc) {
    final provider = Provider.of<SearchProvider>(context, listen: false);

    final randomTimeRange = provider.getRandomTimeRangeFilter();

    final peopleList = provider.personGroupList.take(5).toList();

    final allSmartTags = provider.getAllSmartTag();

    // get random 10 smart tags
    final randomSmartTags = allSmartTags.toList().take(10).toList();

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<SearchHistoryListenBloc, SearchHistoryListenState>(
            builder: (context, state) {
              if (state is! SearchHistoryListenSuccess) {
                return SizedBox();
              }

              if (state.searchHistory.isEmpty) {
                return SizedBox();
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Search history',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        IconButton(
                            onPressed: () {
                              context
                                  .read<SearchHistoryListenBloc>()
                                  .add(DeleteAllSearchHistoryEvent());
                            },
                            icon: Icon(Icons.delete_sweep_outlined))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: state.searchHistory.map((history) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () {
                                controller.text = history.content;
                                controller.selection = TextSelection.collapsed(
                                    offset: controller.text.length);
                                controller.openView();
                              },
                              child: Chip(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                deleteIconColor: Colors.white,
                                backgroundColor: Theme.of(context).primaryColor,
                                label: Text(
                                  history.content,
                                  style: TextStyle(color: Colors.white),
                                ),
                                onDeleted: () {
                                  searchBloc.add(
                                      DeleteSearchHistoryEvent(id: history.id));
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              );
            },
          ),
          if (randomTimeRange.isNotEmpty &&
              randomTimeRange.every((timeRange) =>
                  timeRange['url'] != null &&
                  (timeRange['url'] as String).isNotEmpty))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Times',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 280,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...randomTimeRange.map((timeRange) {
                          final filterName = timeRange['filter'];
                          final imageUrl = timeRange['url'];

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  searchBloc.add(AddSearchHistoryEvent(
                                      content: filterName));
                                  provider.selectFilter(FilterOption(
                                    type: FilterType.timeRange,
                                    value: filterName,
                                    categoryName: 'Time Range',
                                    categoryIcon: Icons.calendar_today_outlined,
                                  ));
                                },
                                child: SizedBox(
                                    width: 130,
                                    height: 130,
                                    child: CachedImage(
                                        imageUrl: imageUrl ?? '',
                                        borderRadius: 20)),
                              ),
                              SizedBox(height: 10),
                              Text(
                                filterName ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          );
                        })
                      ],
                    ),
                  )
                ],
              ),
            ),
          if (peopleList.isNotEmpty) SizedBox(height: 30),
          if (peopleList.isNotEmpty)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'People',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: peopleList.map((people) {
                        final [top, right, bottom, left] = people
                            .faces[0].coordinate
                            .map((e) => e.toDouble())
                            .toList();

                        return Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: GestureDetector(
                            onTap: () {
                              searchBloc.add(
                                  AddSearchHistoryEvent(content: people.name));
                              context.push(Routes.peopleDetailPage,
                                  extra: people);
                            },
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: CroppedImageWidget(
                                      imageUrl: people.faces.first.imageUrl,
                                      boundingBox: Rect.fromLTRB(
                                          left, top, right, bottom))),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
          SizedBox(height: 30),
          if (randomSmartTags.isNotEmpty)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Smart Tags',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: randomSmartTags.map((tag) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              searchBloc
                                  .add(AddSearchHistoryEvent(content: tag));
                              controller.text = tag;
                              controller.selection = TextSelection.collapsed(
                                  offset: controller.text.length);
                              provider.selectFilter(FilterOption(
                                type: FilterType.smartTag,
                                value: tag,
                                categoryName: 'Smart Tags',
                                categoryIcon: Icons.tag,
                              ));
                            },
                            child: Chip(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: getColorScheme(context).secondary,
                                    width: 1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              deleteIcon: null,
                              backgroundColor:
                                  getColorScheme(context).secondary,
                              label: Text(
                                tag,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }

  // NOTE: provide filter suggest -> not type anything
  static List<Widget> buildRandomSuggestions(BuildContext context,
      SearchController controller, SearchHistoryListenBloc searchBloc) {
    final provider = Provider.of<SearchProvider>(context, listen: false);
    final random = Random();
    List<Widget> suggestions = [];

    for (var category in provider.filterCategories) {
      // Bỏ qua TextRetrieve và danh mục trống
      if (category.type == FilterType.textRetrieve ||
          category.options.isEmpty) {
        continue;
      }

      // suggestions.add(
      //   Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Row(
      //       children: [
      //         Icon(category.icon),
      //         const SizedBox(width: 8),
      //         Text(
      //           category.label,
      //           style: Theme.of(context).textTheme.titleMedium,
      //         ),
      //       ],
      //     ),
      //   ),
      // );

      // Chọn ngẫu nhiên tối đa 2 options
      final optionCount = min(3, category.options.length);
      final indices = <int>{};
      while (indices.length < optionCount) {
        indices.add(random.nextInt(category.options.length));
      }

      for (var idx in indices) {
        suggestions.add(
          ListTile(
            leading: Icon(category.icon),
            title: Text(category.options[idx]),
            trailing: IconButton(
              icon: const Icon(Icons.north_west),
              onPressed: () {
                controller.text = category.options[idx];
                controller.selection =
                    TextSelection.collapsed(offset: controller.text.length);
              },
            ),
            onTap: () {
              searchBloc
                  .add(AddSearchHistoryEvent(content: category.options[idx]));
              controller.closeView(category.options[idx]);
              provider.selectFilter(FilterOption(
                type: category.type,
                value: category.options[idx],
                categoryName: category.label,
                categoryIcon: category.icon,
              ));
            },
          ),
        );
      }

      suggestions.add(const Divider());
    }

    return suggestions;
  }

  // NOTE: provider filter suggest -> type something
  static List<Widget> buildMatchingSuggestions(BuildContext context,
      SearchController controller, SearchHistoryListenBloc searchBloc) {
    final provider = Provider.of<SearchProvider>(context, listen: false);
    final String input = controller.text.toLowerCase().trim();

    if (input.isEmpty) {
      return buildRandomSuggestions(context, controller, searchBloc);
    }

    List<Widget> suggestions = [];
    bool hasExactMatch = provider.hasExactMatch(input);

    // Tìm và hiển thị filter khớp 100%
    if (hasExactMatch) {
      for (var category in provider.filterCategories) {
        if (category.type == FilterType.textRetrieve) continue;

        for (var option in category.options) {
          if (option.toLowerCase() == input) {
            // Thêm header
            // suggestions.add(
            //   Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Row(
            //       children: [
            //         Icon(category.icon),
            //         const SizedBox(width: 8),
            //         Text(
            //           category.label,
            //           style: Theme.of(context).textTheme.titleMedium,
            //         ),
            //       ],
            //     ),
            //   ),
            // );

            // Thêm option
            suggestions.add(
              ListTile(
                leading: Icon(category.icon),
                title: Text(option),
                trailing: IconButton(
                  icon: const Icon(Icons.north_west),
                  onPressed: () {
                    controller.text = option;
                    controller.selection =
                        TextSelection.collapsed(offset: controller.text.length);
                  },
                ),
                onTap: () {
                  searchBloc.add(AddSearchHistoryEvent(content: option));
                  controller.closeView(option);
                  provider.selectFilter(FilterOption(
                    type: category.type,
                    value: option,
                    categoryName: category.label,
                    categoryIcon: category.icon,
                  ));
                },
              ),
            );

            suggestions.add(const Divider());
            break;
          }
        }

        if (hasExactMatch && suggestions.isNotEmpty) break;
      }
    }

    if (input.isNotEmpty) {
      suggestions.add(_buildTextRetrieveItem(context, input, controller));
      suggestions.add(const Divider());
    }

    // Thêm các filter có chứa một phần text đang gõ
    for (var category in provider.filterCategories) {
      if (category.type == FilterType.textRetrieve) continue;

      final matchingOptions = category.options
          .where((option) =>
              option.toLowerCase().contains(input) &&
              option.toLowerCase() != input)
          .toList();

      if (matchingOptions.isNotEmpty) {
        // suggestions.add(
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Row(
        //       children: [
        //         Icon(category.icon),
        //         const SizedBox(width: 8),
        //         Text(
        //           category.label,
        //           style: Theme.of(context).textTheme.titleMedium,
        //         ),
        //       ],
        //     ),
        //   ),
        // );

        for (var option in matchingOptions) {
          suggestions.add(
            ListTile(
              leading: Icon(category.icon),
              title: Text(option),
              trailing: IconButton(
                icon: const Icon(Icons.north_west),
                onPressed: () {
                  controller.text = option;
                  controller.selection =
                      TextSelection.collapsed(offset: controller.text.length);
                },
              ),
              onTap: () {
                controller.closeView(option);
                provider.selectFilter(FilterOption(
                  type: category.type,
                  value: option,
                  categoryName: category.label,
                  categoryIcon: category.icon,
                ));
              },
            ),
          );
        }

        suggestions.add(const Divider());
      }
    }

    return suggestions.isEmpty
        ? [_buildTextRetrieveItem(context, input, controller)]
        : suggestions;
  }

  // NOTE: text retrieve -> special item in filter list with special AI
  // NOTE: send text to python server to compare with >< image features
  static Widget _buildTextRetrieveItem(
    BuildContext context,
    String text,
    SearchController controller,
  ) {
    final provider = Provider.of<SearchProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     children: [
        //       Icon(Icons.search, color: Theme.of(context).primaryColor),
        //       const SizedBox(width: 8),
        //       Text(
        //         'Text Retrieve',
        //         style: Theme.of(context).textTheme.titleMedium,
        //       ),
        //     ],
        //   ),
        // ),
        ListTile(
          leading: Icon(Icons.image_search),
          title: Text('"$text"'),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: const Text('Find images related to this text'),
          ),
          onTap: () {
            controller.closeView(text);
            provider.selectFilter(FilterOption(
              type: FilterType.textRetrieve,
              value: text,
              categoryName: 'Text Retrieve',
              categoryIcon: Icons.image_search,
            ));
          },
        ),
      ],
    );
  }
}
