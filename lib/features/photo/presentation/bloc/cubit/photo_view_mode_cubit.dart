import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/common/enum/app_enum.dart';

part 'photo_view_mode_state.dart';

class PhotoViewModeCubit extends Cubit<PhotoViewModeState> {
  PhotoViewModeCubit() : super(PhotoViewModeInitial());

  void changeViewMode(GalleryViewMode viewMode) {
    emit(PhotoViewModeChange(viewMode: viewMode));
  }

  void clearState() {
    emit(PhotoViewModeInitial());
  }
}
