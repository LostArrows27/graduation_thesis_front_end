import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_chunk.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/usecase/get_all_video_chunk.dart';

part 'video_chunk_event.dart';
part 'video_chunk_state.dart';

class VideoChunkBloc extends Bloc<VideoChunkEvent, VideoChunkState> {
  final GetAllVideoChunk _getAllVideoChunk;

  VideoChunkBloc({required GetAllVideoChunk getAllVideoChunk})
      : _getAllVideoChunk = getAllVideoChunk,
        super(VideoChunkInitial()) {
    on<VideoChunkEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetAllChunk>(_getAllChunk);
  }

  void _getAllChunk(GetAllChunk event, Emitter<VideoChunkState> emit) async {
    emit(VideoChunkLoading());

    final res = await _getAllVideoChunk(
        GetAllVideoChunkParams(videoRenderId: event.videoRenderId));

    res.fold((l) => emit(VideoChunkError(message: l.message)),
        (r) => emit(VideoChunkSuccess(videoChunks: r)));
  }
}
