import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/common/enum/app_enum.dart';

part 'choose_image_mode_state.dart';

class ChooseImageModeCubit extends Cubit<ChooseImageModeState> {
  ChooseImageModeCubit()
      : super(ChooseImageModeChange(mode: ChooseImageMode.all));

  void changeViewMode(ChooseImageMode mode) {
    emit(ChooseImageModeChange(mode: mode));
  }

  void clearState() {
    emit(ChooseImageModeChange(mode: ChooseImageMode.all));
  }
}
