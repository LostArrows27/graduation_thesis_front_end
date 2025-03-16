import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/bloc/album_list/album_list_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/usecases/delete_album.dart';

part 'delete_album_state.dart';

class DeleteAlbumCubit extends Cubit<DeleteAlbumState> {
  final DeleteAlbum _deleteAlbum;
  final AlbumListBloc _albumListBloc;

  clear() {
    emit(DeleteAlbumInitial());
  }

  DeleteAlbumCubit(
      {required DeleteAlbum deleteAlbum, required AlbumListBloc albumListBloc})
      : _deleteAlbum = deleteAlbum,
        _albumListBloc = albumListBloc,
        super(DeleteAlbumInitial());

  Future<void> deleteAlbum(String albumId) async {
    final res = await _deleteAlbum(DeleteAlbumParams(albumId: albumId));

    res.fold((l) => emit(DeleteAlbumError(message: l.message)), (r) {
      emit(DeleteAlbumSuccess());
      _albumListBloc.add(DeleteAlbumEvent(albumId: albumId));
    });
  }
}
