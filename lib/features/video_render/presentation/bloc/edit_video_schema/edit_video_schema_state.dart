part of 'edit_video_schema_bloc.dart';

@immutable
sealed class EditVideoSchemaState {}

final class EditVideoSchemaInitial extends EditVideoSchemaState {}

final class EditVideoSchemaLoading extends EditVideoSchemaState {}

final class EditVideoSchemaSuccess extends EditVideoSchemaState {
  final VideoSchema videoSchema;

  EditVideoSchemaSuccess({required this.videoSchema});
}

final class EditVideoSchemaError extends EditVideoSchemaState {
  final String message;

  EditVideoSchemaError({required this.message});
}
