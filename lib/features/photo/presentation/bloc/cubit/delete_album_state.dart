part of 'delete_album_cubit.dart';

@immutable
sealed class DeleteAlbumState {}

final class DeleteAlbumInitial extends DeleteAlbumState {}

final class DeleteAlbumSuccess extends DeleteAlbumState {}

final class DeleteAlbumError extends DeleteAlbumState {
  final String message;

  DeleteAlbumError({required this.message});
}
