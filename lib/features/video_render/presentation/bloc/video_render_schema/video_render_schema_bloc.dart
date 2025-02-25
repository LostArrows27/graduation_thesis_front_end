import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/selected_image.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_schema.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/usecase/get_video_schema.dart';

part 'video_render_schema_event.dart';
part 'video_render_schema_state.dart';

class VideoRenderSchemaBloc
    extends Bloc<VideoRenderSchemaEvent, VideoRenderSchemaState> {
  final GetVideoSchema _getVideoSchema;

  VideoRenderSchemaBloc({
    required GetVideoSchema getVideoSchema,
  })  : _getVideoSchema = getVideoSchema,
        super(VideoRenderSchemaInitial()) {
    on<VideoRenderSchemaEvent>((event, emit) {
      emit(VideoRenderSchemaLoading());
    });

    on<GetVideoSchemaEvent>(_onGetVideoSchema);
  }

  void _onGetVideoSchema(
    GetVideoSchemaEvent event,
    Emitter<VideoRenderSchemaState> emit,
  ) async {
    final res = await _getVideoSchema(GetVideoSchemaParams(
        offlineImagesList: event.offlineImagesList,
        onlineImageIdList: event.onlineImageIdList,
        userId: event.userId));

    res.fold((l) => emit(VideoRenderSchemaFailure(message: l.message)), (r) {
      emit(VideoRenderSchemaSuccess(videoSchema: r));
    });
  }
}
