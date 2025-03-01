part of 'video_chunk_bloc.dart';

@immutable
sealed class VideoChunkState {}

final class VideoChunkInitial extends VideoChunkState {}

final class VideoChunkLoading extends VideoChunkState {}

final class VideoChunkSuccess extends VideoChunkState {
  final VideoChunk videoChunks;

  VideoChunkSuccess({required this.videoChunks});
}

final class VideoChunkError extends VideoChunkState {
  final String message;

  VideoChunkError({required this.message});
}
