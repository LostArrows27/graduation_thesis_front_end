part of 'album_bloc.dart';

@immutable
sealed class AlbumEvent {}

final class CreateAlbumEvent extends AlbumEvent {
  final String name;
  final List<String> imageId;

  CreateAlbumEvent({
    required this.name,
    required this.imageId,
  });
}
