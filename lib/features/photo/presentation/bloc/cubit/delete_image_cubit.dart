import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/usecases/delete_image.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';

part 'delete_image_state.dart';

class DeleteImageCubit extends Cubit<DeleteImageCubitState> {
  final DeleteImage _deleteImage;
  final PhotoBloc _photoBloc;

  DeleteImageCubit(
      {required DeleteImage deleteImage, required PhotoBloc photoBloc})
      : _deleteImage = deleteImage,
        _photoBloc = photoBloc,
        super(DeleteImageCubitInitial());

  Future<void> deleteImage(String imageBucketId, String imageName) async {
    emit(DeleteImageCubitLoading());
    final res = await _deleteImage(
        DeleteImageParams(imageBucketId: imageBucketId, imageName: imageName));

    res.fold((l) => emit(DeleteImageCubitError(message: l.message)), (r) {
      emit(DeleteImageCubitSuccess(
          imageBucketId: imageBucketId, imageName: imageName));
      _photoBloc.add(
          PhotoDeleteEvent(imageBucketId: imageBucketId, imageName: imageName));
    });
  }
}
