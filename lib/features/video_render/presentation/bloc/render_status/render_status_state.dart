part of 'render_status_bloc.dart';

@immutable
sealed class RenderStatusState {}

final class RenderStatusInitial extends RenderStatusState {}

final class FetchRenderLoading extends RenderStatusState {}

final class FetchRenderSuccess extends RenderStatusState {
  final List<VideoRender> renderStatus;

  FetchRenderSuccess({required this.renderStatus});
}

final class FetchRenderFailure extends RenderStatusState {
  final String message;

  FetchRenderFailure({required this.message});
}

final class RenderListUpdateState extends RenderStatusState {
  final VideoRender changedRenderComp;

  RenderListUpdateState({required this.changedRenderComp});
}
