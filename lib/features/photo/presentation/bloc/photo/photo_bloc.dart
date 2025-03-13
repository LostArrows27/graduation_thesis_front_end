// ignore_for_file: library_prefixes
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/utils/group_image.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/usecases/get_all_user_image.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final GetAllUserImage _getAllUserImage;

  PhotoBloc({
    required GetAllUserImage getAllUserImage,
  })  : _getAllUserImage = getAllUserImage,
        super(PhotoInitial()) {
    on<PhotoEvent>((event, emit) {});

    on<PhotoFetchAllEvent>(_onPhotoFetchAllEvent);
    on<PhotoClearEvent>(_onPhotoClearEvent);
    on<PhotoAddImagesEvent>(_onPhotoAddImagesEvent);
    on<PhotoEditCaptionEvent>(_onPhotoEditCaptionEvent);
    on<PhotoDeleteEvent>(_onPhotoDeleteEvent);
  }

  void _onPhotoFetchAllEvent(
      PhotoFetchAllEvent event, Emitter<PhotoState> emit) async {
    emit(PhotoFetchLoading());
    final result =
        await _getAllUserImage(GetAllUserImageParams(userId: event.userId));

    result.fold(
      (failure) {
        emit(PhotoFetchFailure(message: failure.message));
      },
      (photos) {
        emit(PhotoFetchSuccess(
            photos: photos,
            groupedByDate: groupImageByDate(photos),
            groupedByMonth: groupImageByMonth(photos),
            groupedByYear: groupImageByYear(photos)));
      },
    );
  }

  void _onPhotoClearEvent(
      PhotoClearEvent event, Emitter<PhotoState> emit) async {
    emit(PhotoInitial());
  }

  void _onPhotoAddImagesEvent(
      PhotoAddImagesEvent event, Emitter<PhotoState> emit) async {
    if (state is PhotoFetchSuccess) {
      final currentState = state as PhotoFetchSuccess;
      final totalPhotos = [...currentState.photos, ...event.photos];
      emit(PhotoFetchSuccess(
          photos: totalPhotos,
          groupedByDate: groupImageByDate(totalPhotos),
          groupedByMonth: groupImageByMonth(totalPhotos),
          groupedByYear: groupImageByYear(totalPhotos)));
    } else {
      emit(PhotoFetchSuccess(
          photos: event.photos,
          groupedByDate: groupImageByDate(event.photos),
          groupedByMonth: groupImageByMonth(event.photos),
          groupedByYear: groupImageByYear(event.photos)));
    }
  }

  void _onPhotoEditCaptionEvent(
      PhotoEditCaptionEvent event, Emitter<PhotoState> emit) async {
    if (state is PhotoFetchSuccess) {
      final currentState = state as PhotoFetchSuccess;
      final updatedPhotos = currentState.photos
          .map((photo) => photo.id == event.imageId
              ? photo.copyWith(caption: event.caption)
              : photo)
          .toList();
      emit(PhotoFetchSuccess(
          photos: updatedPhotos,
          groupedByDate: groupImageByDate(updatedPhotos),
          groupedByMonth: groupImageByMonth(updatedPhotos),
          groupedByYear: groupImageByYear(updatedPhotos)));
    } else {
      emit(PhotoFetchFailure(message: 'Cannot edit caption'));
    }
  }

  void _onPhotoDeleteEvent(
      PhotoDeleteEvent event, Emitter<PhotoState> emit) async {
    if (state is PhotoFetchSuccess) {
      final currentState = state as PhotoFetchSuccess;
      final updatedPhotos = currentState.photos
          .where((photo) => photo.imageName != event.imageName)
          .toList();
      emit(PhotoFetchSuccess(
          photos: updatedPhotos,
          groupedByDate: groupImageByDate(updatedPhotos),
          groupedByMonth: groupImageByMonth(updatedPhotos),
          groupedByYear: groupImageByYear(updatedPhotos)));
    } else {
      emit(PhotoFetchFailure(message: 'Cannot delete photo'));
    }
  }
}
