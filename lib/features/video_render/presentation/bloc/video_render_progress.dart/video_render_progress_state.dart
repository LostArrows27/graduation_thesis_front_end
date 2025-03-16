part of 'video_render_progress_bloc.dart';

@immutable
sealed class VideoRenderProgressState {}

final class VideoRenderProgressInitial extends VideoRenderProgressState {}

final class VideoRenderProgressLoading extends VideoRenderProgressState {}

final class VideoRenderProgressUpdate extends VideoRenderProgressState {
  final int progress;

  VideoRenderProgressUpdate({required this.progress});
}

final class VideoRenderProgressSuccess extends VideoRenderProgressState {}

final class VideoRenderProgressFailure extends VideoRenderProgressState {}
