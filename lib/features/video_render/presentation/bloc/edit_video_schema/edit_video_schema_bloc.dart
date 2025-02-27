import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_schema.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/usecase/edit_video_schema.dart';

part 'edit_video_schema_event.dart';
part 'edit_video_schema_state.dart';

class EditVideoSchemaBloc
    extends Bloc<EditVideoSchemaEvent, EditVideoSchemaState> {
  final EditVideoSchema _editVideoSchema;

  EditVideoSchemaBloc({
    required EditVideoSchema editVideoSchema,
  })  : _editVideoSchema = editVideoSchema,
        super(EditVideoSchemaInitial()) {
    on<EditVideoSchemaEvent>((event, emit) {
      emit(EditVideoSchemaLoading());
    });

    on<SendEditVideoSchema>(_onSendEditVideoSchema);
  }

  void _onSendEditVideoSchema(
      SendEditVideoSchema event, Emitter<EditVideoSchemaState> emit) async {
    final res = await _editVideoSchema(EditVideoSchemaParams(
        scale: event.scale, videoSchema: event.videoSchema));

    res.fold((l) => emit(EditVideoSchemaError(message: l.message)), (r) {
      emit(EditVideoSchemaSuccess(videoSchema: r));
    });
  }
}
