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

  PhotoBloc({required GetAllUserImage getAllUserImage})
      : _getAllUserImage = getAllUserImage,
        super(PhotoInitial()) {
    on<PhotoEvent>((event, emit) {
      emit(PhotoFetchLoading());
    });

    on<PhotoFetchAllEvent>(_onPhotoFetchAllEvent);
  }

  void _onPhotoFetchAllEvent(
      PhotoFetchAllEvent event, Emitter<PhotoState> emit) async {
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
}
