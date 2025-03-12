import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/features/search/presentation/bloc/bloc/search_history_listen_bloc.dart';

class SearchHistoryVerticalList extends StatefulWidget {
  const SearchHistoryVerticalList({super.key});

  @override
  State<SearchHistoryVerticalList> createState() =>
      _SearchHistoryVerticalListState();
}

class _SearchHistoryVerticalListState extends State<SearchHistoryVerticalList> {
  late SearchHistoryListenBloc _searchHistoryListenBloc;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchHistoryListenBloc = context.read<SearchHistoryListenBloc>();
      _searchHistoryListenBloc.add(FetchAllSearchHistory());
      _searchHistoryListenBloc.add(ListenSearchHistoryChange());
    });
  }

  @override
  void dispose() {
    _searchHistoryListenBloc.add(UnListenSearchHistoryChange());
    super.dispose();
  }

  Widget buildSuggestion(IconData icon, String title) {
    return Column(
      children: [
        SizedBox(
          height: 70,
          width: double.infinity,
          child: Material(
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      size: 24,
                    ),
                    SizedBox(width: 15),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color:
              Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.3),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchHistoryListenBloc, SearchHistoryListenState>(
      listener: (context, state) {
        if (state is SearchHistoryListenFailure) {
          return showErrorSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is SearchHistoryListenInitial ||
            state is SearchHistoryListenLoading) {
          return SizedBox(
              height: 500, child: Center(child: CircularProgressIndicator()));
        }

        if (state is SearchHistoryListenFailure) {
          return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Try search by',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(height: 10),
                  buildSuggestion(
                      Icons.calendar_month_outlined, 'Image time range'),
                  buildSuggestion(Icons.tag, 'Location, event, activity tags'),
                  buildSuggestion(Icons.face, 'People in your image'),
                  buildSuggestion(Icons.text_fields_rounded,
                      'Describe the image you want to find'),
                  buildSuggestion(Icons.photo_album_outlined, 'Album name'),
                ],
              ));
        }

        return Column(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if ((state as SearchHistoryListenSuccess)
                        .searchHistory
                        .isNotEmpty)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Search history',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              IconButton(
                                  onPressed: () {
                                    _searchHistoryListenBloc
                                        .add(DeleteAllSearchHistoryEvent());
                                  },
                                  icon: Icon(Icons.delete_sweep_outlined))
                            ],
                          ),
                          ...state.searchHistory.take(3).map((e) {
                            return buildSuggestion(Icons.history, e.content);
                          }),
                          SizedBox(height: 20),
                        ],
                      ),
                    Text('Try search by',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(height: 10),
                    buildSuggestion(
                        Icons.calendar_month_outlined, 'Image time range'),
                    buildSuggestion(
                        Icons.tag, 'Location, event, activity tags'),
                    buildSuggestion(Icons.face, 'People in your image'),
                    buildSuggestion(Icons.text_fields_rounded,
                        'Describe the image you want to find'),
                    buildSuggestion(Icons.photo_album_outlined, 'Album name'),
                  ],
                )),
          ],
        );
      },
    );
  }
}
