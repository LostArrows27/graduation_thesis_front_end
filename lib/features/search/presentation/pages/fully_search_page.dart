import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/common/service/speech_recognition_service.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/failure.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/loader.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/bloc/album_list/album_list_bloc.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/bloc/person_group/person_group_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';
import 'package:graduation_thesis_front_end/features/search/presentation/bloc/bloc/search_history_listen_bloc.dart';
import 'package:graduation_thesis_front_end/features/search/presentation/bloc/search_history/search_history_bloc.dart';
import 'package:graduation_thesis_front_end/features/search/presentation/provider/search_provider.dart';
import 'package:graduation_thesis_front_end/features/search/presentation/widgets/photo_grid.dart';
import 'package:graduation_thesis_front_end/features/search/presentation/widgets/search_filter_suggestion.dart';
import 'package:graduation_thesis_front_end/init_dependencies.dart';
import 'package:provider/provider.dart';

class FullySearchPage extends StatefulWidget {
  const FullySearchPage({super.key});

  @override
  State<FullySearchPage> createState() => _FullySearchPageState();
}

class _FullySearchPageState extends State<FullySearchPage> {
  late SearchHistoryBloc _searchHistoryBloc;

  @override
  void initState() {
    super.initState();
    _searchHistoryBloc = serviceLocator<SearchHistoryBloc>();
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

                  return BlocProvider(
                    create: (context) => _searchHistoryBloc,
                    child: ChangeNotifierProvider(
                        create: (context) => SearchProvider(
                              searchHistoryBloc: _searchHistoryBloc,
                              personGroupList: personGroupState
                                      is PersonGroupSuccess
                                  ? personGroupState.personGroups
                                  : (personGroupState as ChangeGroupNameSuccess)
                                      .personGroups,
                              albumList:
                                  (albumListState as AlbumListLoaded).albums,
                              photoList:
                                  (photoState as PhotoFetchSuccess).photos,
                            ),
                        builder: (context, child) {
                          return BlocProvider(
                            create: (_) =>
                                serviceLocator<SearchHistoryListenBloc>(),
                            child: SearchProviderBody(
                              providerContext: context,
                            ),
                          );
                        }),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class SearchProviderBody extends StatefulWidget {
  final BuildContext providerContext;
  final SearchController _searchController;

  SearchProviderBody(
      {super.key,
      required this.providerContext,
      SearchController? searchController})
      : _searchController = searchController ?? SearchController();

  @override
  State<SearchProviderBody> createState() => _SearchProviderBodyState();
}

class _SearchProviderBodyState extends State<SearchProviderBody> {
  late SearchHistoryListenBloc _searchHistoryListenBloc;
  bool _mounted = true;
  bool _isListening = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchHistoryListenBloc = context.read<SearchHistoryListenBloc>();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_mounted && mounted) {
        _searchHistoryListenBloc.add(FetchAllSearchHistory());
        _searchHistoryListenBloc.add(ListenSearchHistoryChange());
      }
    });
  }

  @override
  void dispose() {
    _mounted = false;
    _searchHistoryListenBloc.add(UnListenSearchHistoryChange());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        children: [
          SizedBox(height: 50),
          Consumer<SearchProvider>(
            builder: (context, provider, _) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: SearchAnchor.bar(
                  isFullScreen: false,
                  searchController: widget._searchController,
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
                  barBackgroundColor:
                      WidgetStateProperty.all(Colors.transparent),
                  barLeading: GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Icon(Icons.arrow_back)),
                  barElevation: WidgetStateProperty.all(0),
                  barHintText: 'Times, place, people, things...',
                  // barTrailing: <Widget>[
                  //   Tooltip(
                  //     message: 'Voice search',
                  //     child: IconButton(
                  //       isSelected: provider.isVoiceSearchOn,
                  //       onPressed: () => provider.toggleVoiceSearch(),
                  //       icon: const Icon(Icons.mic_off),
                  //       selectedIcon: const Icon(Icons.mic),
                  //     ),
                  //   )
                  // ],
                  barTrailing: <Widget>[
                    Tooltip(
                      message: 'Voice search',
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _isListening = !_isListening;
                          });
                          provider.toggleVoiceSearch(
                            onTextRecognized: (text) {
                              widget._searchController.text = text;
                              widget._searchController.openView();
                              setState(() {
                                _isListening = false;
                              });
                            },
                          );
                        },
                        icon: const Icon(Icons.mic),
                      ),
                    )
                  ],
                  suggestionsBuilder: (context, controller) {
                    if (controller.text.isEmpty) {
                      return SearchFilterSuggestions.buildRandomSuggestions(
                          widget.providerContext,
                          controller,
                          context.read<SearchHistoryListenBloc>());
                    }
                    return SearchFilterSuggestions.buildMatchingSuggestions(
                        widget.providerContext,
                        controller,
                        context.read<SearchHistoryListenBloc>());
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
                              avatar:
                                  Icon(provider.selectedFilter!.categoryIcon),
                              label: Text(
                                  '${provider.selectedFilter!.categoryName}: ${provider.selectedFilter!.value}'),
                              onDeleted: () => provider.clearFilter(),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 20),

                    // display result / search filter
                    BlocConsumer<SearchHistoryBloc, SearchHistoryState>(
                      listener: (context, state) {
                        if (state is SearchHistoryError) {
                          return showErrorSnackBar(context, state.message);
                        }

                        if (state is SearchHistoryLoaded) {
                          final searchPhotoList = state.searchHistory.result;

                          searchPhotoList.sort(
                              (a, b) => b.similarity.compareTo(a.similarity));

                          List<Photo> searchResult = [];

                          for (final searchPhoto in searchPhotoList) {
                            final photoList = provider.allPhotos;
                            searchResult.add(photoList.firstWhere((element) =>
                                element.id == searchPhoto.imageId));
                          }

                          provider.setSearchResults(searchResult);
                        }
                      },
                      builder: (context, state) {
                        if (state is SearchHistoryLoading) {
                          return Expanded(
                              child: Center(
                            child: CircularProgressIndicator(),
                          ));
                        }

                        return Expanded(
                          child: provider.selectedFilter == null
                              ? SearchFilterSuggestions
                                  .buildSearchSuggestResults(
                                      context,
                                      widget._searchController,
                                      context.read<SearchHistoryListenBloc>())
                              : provider.searchResults.isEmpty
                                  ? const Center(child: Text('No photos found'))
                                  : PhotoGrid(photos: provider.searchResults),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      if (_isListening)
        Positioned.fill(
          child: SpeechRecognitionService.buildListeningOverlay(
            context,
            () {
              final provider =
                  Provider.of<SearchProvider>(context, listen: false);
              provider.stopVoiceSearch();
              setState(() {
                _isListening = false;
              });
            },
          ),
        )
    ]);
  }
}
