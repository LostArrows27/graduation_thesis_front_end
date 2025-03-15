import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/usecases/upload_images.dart';

part 'upload_photo_event.dart';
part 'upload_photo_state.dart';

class UploadPhotoBloc extends Bloc<UploadPhotoEvent, UploadPhotoState> {
  final UploadImages _uploadImages;

  UploadPhotoBloc({required UploadImages uploadImages})
      : _uploadImages = uploadImages,
        super(UploadPhotoInitial()) {
    on<UploadPhotoEvent>((event, emit) {
      if (event is UploadImagesEvent) {
        emit(UploadImagesLoading());
      }
    });

    on<UploadImagesEvent>(_onUploadImagesEvent);
  }

  void _onUploadImagesEvent(
      UploadImagesEvent event, Emitter<UploadPhotoState> emit) async {
        
    final result =
        await _uploadImages(UploadImagesParams(images: event.images));

    result.fold(
      (failure) => emit(UploadImagesFailure(message: failure.message)),
      (photos) => emit(UploadImageSuccess(photos: photos)),
    );
  }
}
