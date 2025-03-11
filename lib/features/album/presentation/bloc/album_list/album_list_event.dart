part of 'album_list_bloc.dart';

@immutable
sealed class AlbumListEvent {}

final class GetAllAlbumEvent extends AlbumListEvent {}

final class AddAlbumEvent extends AlbumListEvent {
  final Album album;

  AddAlbumEvent({required this.album});
}

