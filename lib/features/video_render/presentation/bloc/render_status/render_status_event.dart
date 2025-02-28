part of 'render_status_bloc.dart';

@immutable
sealed class RenderStatusEvent {}

final class FetchAllRender extends RenderStatusEvent {}

final class ListenRenderListChange extends RenderStatusEvent {}

final class UnSubcribeToRenderListChannel extends RenderStatusEvent {}

final class RenderListUpdate extends RenderStatusEvent {
  final VideoRender updatedRenderComp;

  RenderListUpdate({required this.updatedRenderComp});
}
