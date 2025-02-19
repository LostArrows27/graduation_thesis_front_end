part of 'photo_view_mode_cubit.dart';

@immutable
sealed class PhotoViewModeState {}

final class PhotoViewModeInitial extends PhotoViewModeState {}

final class PhotoViewModeChange extends PhotoViewModeState {
  final GalleryViewMode viewMode;

  PhotoViewModeChange({required this.viewMode});
}
