import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/repositories/video_render_repository.dart';

part 'video_render_progress_event.dart';
part 'video_render_progress_state.dart';

class VideoRenderProgressBloc
    extends Bloc<VideoRenderProgressEvent, VideoRenderProgressState> {
  final VideoRenderRepository _videoRenderRepository;

  VideoRenderProgressBloc(
      {required VideoRenderRepository videoRenderRepository})
      : _videoRenderRepository = videoRenderRepository,
        super(VideoRenderProgressInitial()) {
    on<VideoRenderProgressEvent>((event, emit) {});

    on<ListenVideoRenderProgressEvent>(_onListenVideoRenderProgressEvent);

    on<UnSubcribeToVideoRenderChannel>(_onUnSubcribeToVideoRenderChannel);

    on<VideoRenderUpdateEvent>(_onVideoRenderUpdateEvent);

    on<VideoRenderSuccessEvent>(_onVideoRenderSuccessEvent);

    on<VideoRenderFailureEvent>(_onVideoRenderFailureEvent);

    on<FirstFetchVideoProgress>(_onFirstFetchVideoProgress);
  }

  void _onFirstFetchVideoProgress(FirstFetchVideoProgress event,
      Emitter<VideoRenderProgressState> emit) async {
    final res = await _videoRenderRepository.getVideoRenderStatus(
        videoRenderId: event.videoRenderId);

    res.fold((l) => emit(VideoRenderProgressFailure()), (r) {
      if (r.status == 'completed') {
        emit(VideoRenderProgressSuccess());
      } else if (r.status == 'in_progress' || r.status == 'pending') {
        emit(VideoRenderProgressUpdate(progress: r.progress));
      } else {
        emit(VideoRenderProgressFailure());
      }
    });
  }

  void _onVideoRenderFailureEvent(
      VideoRenderFailureEvent event, Emitter<VideoRenderProgressState> emit) {
    emit(VideoRenderProgressFailure());
  }

  void _onVideoRenderSuccessEvent(
      VideoRenderSuccessEvent event, Emitter<VideoRenderProgressState> emit) {
    emit(VideoRenderProgressSuccess());
  }

  void _onVideoRenderUpdateEvent(
      VideoRenderUpdateEvent event, Emitter<VideoRenderProgressState> emit) {
    emit(VideoRenderProgressUpdate(progress: event.progress));
  }

  void _onUnSubcribeToVideoRenderChannel(UnSubcribeToVideoRenderChannel event,
      Emitter<VideoRenderProgressState> emit) {
    _videoRenderRepository.unSubcribeToVideoRenderChannel(
        channelName: event.channelName);
  }

  void _onListenVideoRenderProgressEvent(ListenVideoRenderProgressEvent event,
      Emitter<VideoRenderProgressState> emit) async {
    _videoRenderRepository.onVideoRenderStatusChange(
        videoRenderId: event.videoRenderId,
        callback: (videoProgress) async {
          String status = videoProgress.status;

          switch (status) {
            case "pending":
            case "in_progress":
              add(VideoRenderUpdateEvent(progress: videoProgress.progress));
              break;
            case "completed":
              add(VideoRenderSuccessEvent());
              break;
            case "failed":
              add(VideoRenderFailureEvent());
              break;
          }
        });
  }
}
