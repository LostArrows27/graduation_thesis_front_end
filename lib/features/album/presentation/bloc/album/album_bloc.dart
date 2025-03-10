import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/features/album/domain/entities/album.dart';
import 'package:graduation_thesis_front_end/features/album/domain/usecases/create_album.dart';

part 'album_event.dart';
part 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final CreateAlbum _createAlbum;

  AlbumBloc({required CreateAlbum createAlbum})
      : _createAlbum = createAlbum,
        super(AlbumInitial()) {
    on<AlbumEvent>((event, emit) {});

    on<CreateAlbumEvent>(_onCreateAlbum);
  }

  void _onCreateAlbum(CreateAlbumEvent event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    final result = await _createAlbum(
      CreateAlbumParams(
        name: event.name,
        imageIdList: event.imageId,
      ),
    );
    result.fold(
      (failure) => emit(AlbumError(message: failure.message)),
      (album) => emit(AlbumSuccess(album: album)),
    );
  }
}
