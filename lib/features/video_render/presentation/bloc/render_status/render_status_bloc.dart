import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_render.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/repositories/video_render_repository.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/usecase/get_all_video_render.dart';

part 'render_status_event.dart';
part 'render_status_state.dart';

class RenderStatusBloc extends Bloc<RenderStatusEvent, RenderStatusState> {
  final GetAllVideoRender _getAllVideoRender;
  final VideoRenderRepository _videoRenderRepository;

  RenderStatusBloc(
      {required GetAllVideoRender getAllVideoRender,
      required VideoRenderRepository videoRenderRepository})
      : _getAllVideoRender = getAllVideoRender,
        _videoRenderRepository = videoRenderRepository,
        super(RenderStatusInitial()) {
    on<RenderStatusEvent>((event, emit) {});

    on<FetchAllRender>(_onFetchAllRender);

    on<ListenRenderListChange>(_onListenRenderListChange);

    on<UnSubcribeToRenderListChannel>(_onUnSubcribeToRenderListChannel);

    on<RenderListUpdate>(_onRenderListUpdate);
  }

  void _onFetchAllRender(
    FetchAllRender event,
    Emitter<RenderStatusState> emit,
  ) async {
    emit(FetchRenderLoading());
    final res = await _getAllVideoRender(NoParams());

    res.fold(
      (l) => emit(FetchRenderFailure(message: l.message)),
      (r) => emit(FetchRenderSuccess(renderStatus: r)),
    );
  }

  void _onListenRenderListChange(
    ListenRenderListChange event,
    Emitter<RenderStatusState> emit,
  ) {
    _videoRenderRepository.listenVideoRenderListChange(
        callback: (updatedRenderComp) {
      add(RenderListUpdate(updatedRenderComp: updatedRenderComp));
    });
  }

  void _onUnSubcribeToRenderListChannel(
    UnSubcribeToRenderListChannel event,
    Emitter<RenderStatusState> emit,
  ) {
    _videoRenderRepository.unSubcribeToRenderListChannel();
  }

  void _onRenderListUpdate(
    RenderListUpdate event,
    Emitter<RenderStatusState> emit,
  ) {
    emit(RenderListUpdateState(changedRenderComp: event.updatedRenderComp));
  }
}
