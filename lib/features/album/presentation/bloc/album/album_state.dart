part of 'album_bloc.dart';

@immutable
sealed class AlbumState {}

final class AlbumInitial extends AlbumState {}

final class AlbumLoading extends AlbumState {}

final class AlbumSuccess extends AlbumState {
  final Album album;

  AlbumSuccess({required this.album});
}

final class AlbumError extends AlbumState {
  final String message;

  AlbumError({required this.message});
}
