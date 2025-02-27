part of 'video_render_progress_bloc.dart';

@immutable
sealed class VideoRenderProgressEvent {}

final class ListenVideoRenderProgressEvent extends VideoRenderProgressEvent {
  final String videoRenderId;

  ListenVideoRenderProgressEvent({required this.videoRenderId});
}

final class UnSubcribeToVideoRenderChannel extends VideoRenderProgressEvent {
  final String channelName;

  UnSubcribeToVideoRenderChannel({required this.channelName});
}

final class VideoRenderUpdateEvent extends VideoRenderProgressEvent {
  final int progress;

  VideoRenderUpdateEvent({required this.progress});
}

final class VideoRenderSuccessEvent extends VideoRenderProgressEvent {}

final class VideoRenderFailureEvent extends VideoRenderProgressEvent {}

final class FirstFetchVideoProgress extends VideoRenderProgressEvent {
  final String videoRenderId;

  FirstFetchVideoProgress({required this.videoRenderId});
}
