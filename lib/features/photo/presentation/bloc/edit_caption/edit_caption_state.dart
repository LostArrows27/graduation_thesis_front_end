part of 'edit_caption_bloc.dart';

@immutable
sealed class EditCaptionState {}

final class EditCaptionInitial extends EditCaptionState {}

final class EditCaptionLoading extends EditCaptionState {}

final class EditCaptionSuccess extends EditCaptionState {
  final String caption;
  final String imageId;

  EditCaptionSuccess({
    required this.caption,
    required this.imageId,
  });
}

final class EditCaptionFailure extends EditCaptionState {
  final String message;

  EditCaptionFailure({
    required this.message,
  });
}
