part of 'album_list_bloc.dart';

@immutable
sealed class AlbumListState {}

final class AlbumListInitial extends AlbumListState {}

final class AlbumListLoading extends AlbumListState {}

final class AlbumListLoaded extends AlbumListState {
  final List<Album> albums;

  AlbumListLoaded({required this.albums});
}

final class AlbumListError extends AlbumListState {
  final String message;

  AlbumListError({required this.message});
}
