part of 'video_render_schema_bloc.dart';

@immutable
sealed class VideoRenderSchemaEvent {}

class GetVideoSchemaEvent extends VideoRenderSchemaEvent {
  final List<SelectedImage> offlineImagesList;
  final List<String> onlineImageIdList;
  final String userId;

  GetVideoSchemaEvent(
      {required this.offlineImagesList,
      required this.onlineImageIdList,
      required this.userId});
}
