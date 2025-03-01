part of 'video_chunk_bloc.dart';

@immutable
sealed class VideoChunkEvent {}

final class GetAllChunk extends VideoChunkEvent {
  final String videoRenderId;

  GetAllChunk({required this.videoRenderId});
}
