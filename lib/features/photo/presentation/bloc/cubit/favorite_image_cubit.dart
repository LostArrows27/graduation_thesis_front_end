import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/repository/photo_repository.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';

part 'favorite_image_state.dart';

class FavoriteImageCubit extends Cubit<FavoriteImageState> {
  final PhotoBloc _photoBloc;
  final PhotoRepository _photoRepository;

  clear() {
    emit(FavoriteImageInitial());
  }

  FavoriteImageCubit(
      {required PhotoBloc photoBloc, required PhotoRepository photoRepository})
      : _photoBloc = photoBloc,
        _photoRepository = photoRepository,
        super(FavoriteImageInitial());

  Future<void> favoriteImage(String imageId, bool isFavorite) async {
    final res = await _photoRepository.favoriteImage(
        imageId: imageId, isFavorite: isFavorite);

    res.fold((l) => emit(FavoriteImageError(message: l.message)), (r) {
      emit(FavoriteImageSuccess(imageId: imageId, isFavorite: isFavorite));
      _photoBloc
          .add(PhotoFavoriteEvent(imageId: imageId, isFavorite: isFavorite));
    });
  }
}
