part of 'choose_image_mode_cubit.dart';

@immutable
sealed class ChooseImageModeState {}


final class ChooseImageModeChange extends ChooseImageModeState {
  final ChooseImageMode mode;

  ChooseImageModeChange({required this.mode});
}
