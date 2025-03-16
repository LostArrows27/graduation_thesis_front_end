part of 'edit_caption_bloc.dart';

@immutable
sealed class EditCaptionEvent {}

final class ChangeCaptionEvent extends EditCaptionEvent {
  final String caption;
  final String imageId;

  ChangeCaptionEvent({
    required this.caption,
    required this.imageId,
  });
}

final class EditCaptionClear extends EditCaptionEvent {}
