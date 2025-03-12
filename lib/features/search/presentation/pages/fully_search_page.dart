import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/failure.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/loader.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/bloc/album_list/album_list_bloc.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/bloc/person_group/person_group_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';
import 'package:graduation_thesis_front_end/features/search/presentation/provider/search_provider.dart';
import 'package:graduation_thesis_front_end/features/search/presentation/widgets/photo_grid.dart';
import 'package:graduation_thesis_front_end/features/search/presentation/widgets/search_filter_suggestion.dart';
import 'package:provider/provider.dart';

class FullySearchPage extends StatefulWidget {
  const FullySearchPage({super.key});

  @override
  State<FullySearchPage> createState() => _FullySearchPageState();
}

class _FullySearchPageState extends State<FullySearchPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final personGroupBloc = context.read<PersonGroupBloc>();
      if (personGroupBloc.state is PersonGroupInitial) {
        personGroupBloc.add(PersonGroupFetch());
      }

      final albumListBloc = context.read<AlbumListBloc>();

      if (albumListBloc.state is AlbumListInitial) {
        albumListBloc.add(GetAllAlbumEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PhotoBloc, PhotoState>(
        builder: (context, photoState) {
          if (photoState is PhotoFetchLoading || photoState is PhotoInitial) {
            return Loader(
              message: 'Loading photo list...',
            );
          }

          if (photoState is PhotoFetchFailure) {
            return FailureWidget(message: photoState.message);
          }

          return BlocBuilder<AlbumListBloc, AlbumListState>(
            builder: (context, albumListState) {
              if (albumListState is AlbumListLoading ||
                  albumListState is AlbumListInitial) {
                return Loader(
                  message: 'Loading album list...',
                );
              }

              if (albumListState is AlbumListError) {
                return FailureWidget(message: albumListState.message);
              }

              return BlocBuilder<PersonGroupBloc, PersonGroupState>(
                builder: (context, personGroupState) {
                  if (personGroupState is PersonGroupLoading ||
                      personGroupState is PersonGroupInitial) {
                    return Loader(message: 'Loading people group...');
                  }

                  if (personGroupState is PersonGroupFailure) {
                    return FailureWidget(message: personGroupState.message);
                  }

                  if (personGroupState is! PersonGroupSuccess &&
                      personGroupState is! ChangeGroupNameSuccess) {
                    return FailureWidget(message: 'Unknown error');
                  }

                  return ChangeNotifierProvider(
                      create: (context) => SearchProvider(
                            personGroupList: personGroupState
                                    is PersonGroupSuccess
                                ? personGroupState.personGroups
                                : (personGroupState as ChangeGroupNameSuccess)
                                    .personGroups,
                            albumList:
                                (albumListState as AlbumListLoaded).albums,
                            photoList: (photoState as PhotoFetchSuccess).photos,
                          ),
                      builder: (context, child) {
                        return SearchProviderBody(
                          providerContext: context,
                        );
                      });
                },
              );
            },
          );
        },
      ),
    );
  }
}

class SearchProviderBody extends StatelessWidget {
  final BuildContext providerContext;

  final SearchController _searchController;

  SearchProviderBody(
      {super.key,
      required this.providerContext,
      SearchController? searchController})
      : _searchController = searchController ?? SearchController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50),
        Consumer<SearchProvider>(
          builder: (context, provider, _) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: SearchAnchor.bar(
                isFullScreen: false,
                searchController: _searchController,
                barHintStyle: WidgetStateProperty.all(
                  TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
                barShape: WidgetStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                dividerColor: Colors.grey[200],
                viewElevation: 1,
                viewBackgroundColor: Colors.white,
                viewShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                barOverlayColor: WidgetStateProperty.all(Colors.white),
                barBackgroundColor: WidgetStateProperty.all(Colors.transparent),
                barLeading: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back)),
                barElevation: WidgetStateProperty.all(0),
                barHintText: 'Times, place, people, things...',
                barTrailing: <Widget>[
                  Tooltip(
                    message: 'Voice search',
                    child: IconButton(
                      isSelected: provider.isVoiceSearchOn,
                      onPressed: () => provider.toggleVoiceSearch(),
                      icon: const Icon(Icons.mic_off),
                      selectedIcon: const Icon(Icons.mic),
                    ),
                  )
                ],
                suggestionsBuilder: (context, controller) {
                  if (controller.text.isEmpty) {
                    return SearchFilterSuggestions.buildRandomSuggestions(
                      providerContext,
                      controller,
                    );
                  }
                  return SearchFilterSuggestions.buildMatchingSuggestions(
                    providerContext,
                    controller,
                  );
                },
              ),
            );
          },
        ),
        Expanded(
          child: Consumer<SearchProvider>(
            builder: (context, provider, _) {
              return Column(
                children: [
                  // display selected filter
                  if (provider.selectedFilter != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Wrap(
                        spacing: 8.0,
                        children: [
                          Chip(
                            avatar: Icon(provider.selectedFilter!.categoryIcon),
                            label: Text(
                                '${provider.selectedFilter!.categoryName}: ${provider.selectedFilter!.value}'),
                            onDeleted: () => provider.clearFilter(),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 20),

                  // display result / search filter
                  Expanded(
                    child: provider.selectedFilter == null
                        ? SearchFilterSuggestions.buildSearchSuggestResults(
                            context, _searchController)
                        : provider.searchResults.isEmpty
                            ? const Center(child: Text('No photos found'))
                            : PhotoGrid(photos: provider.searchResults),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
