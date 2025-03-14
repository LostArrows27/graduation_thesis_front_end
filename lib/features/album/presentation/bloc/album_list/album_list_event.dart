part of 'album_list_bloc.dart';

@immutable
sealed class AlbumListEvent {}

final class GetAllAlbumEvent extends AlbumListEvent {}

final class ReloadAlbum extends AlbumListEvent {}

final class AddAlbumEvent extends AlbumListEvent {
  final Album album;

  AddAlbumEvent({required this.album});
}

final class DeleteAlbumEvent extends AlbumListEvent {
  final String albumId;

  DeleteAlbumEvent({required this.albumId});
}

final class ChangeAlbumNameEvent extends AlbumListEvent {
  final String albumId;
  final String albumName;

  ChangeAlbumNameEvent({required this.albumId, required this.albumName});
}
