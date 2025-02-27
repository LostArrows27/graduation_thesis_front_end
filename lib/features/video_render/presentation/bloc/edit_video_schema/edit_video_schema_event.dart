part of 'edit_video_schema_bloc.dart';

@immutable
sealed class EditVideoSchemaEvent {}

class SendEditVideoSchema extends EditVideoSchemaEvent {
  final VideoSchema videoSchema;
  final String scale;

  SendEditVideoSchema({required this.videoSchema, required this.scale});
}
