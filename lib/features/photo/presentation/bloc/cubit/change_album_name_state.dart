part of 'change_album_name_cubit.dart';

@immutable
sealed class ChangeAlbumNameState {}

final class ChangeAlbumNameInitial extends ChangeAlbumNameState {}

final class ChangeAlbumNameLoading extends ChangeAlbumNameState {}

final class ChangeAlbumNameSuccess extends ChangeAlbumNameState {
  final String newAlbumName;

  ChangeAlbumNameSuccess({required this.newAlbumName});
}

final class ChangeAlbumNameError extends ChangeAlbumNameState {
  final String message;

  ChangeAlbumNameError({required this.message});
}
