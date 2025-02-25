part of 'video_render_schema_bloc.dart';

@immutable
sealed class VideoRenderSchemaState {}

final class VideoRenderSchemaInitial extends VideoRenderSchemaState {}

final class VideoRenderSchemaLoading extends VideoRenderSchemaState {}

final class VideoRenderSchemaSuccess extends VideoRenderSchemaState {
  final VideoSchema videoSchema;

  VideoRenderSchemaSuccess({required this.videoSchema});
}

final class VideoRenderSchemaFailure extends VideoRenderSchemaState {
  final String message;

  VideoRenderSchemaFailure({required this.message});
}
