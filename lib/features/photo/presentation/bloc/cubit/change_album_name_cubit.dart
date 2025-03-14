import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/bloc/album_list/album_list_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/usecases/change_album_name.dart';

part 'change_album_name_state.dart';

class ChangeAlbumNameCubit extends Cubit<ChangeAlbumNameState> {
  final ChangeAlbumName _changeAlbumName;
  final AlbumListBloc _albumListBloc;

  ChangeAlbumNameCubit({
    required ChangeAlbumName changeAlbumName,
    required AlbumListBloc albumListBloc,
  })  : _changeAlbumName = changeAlbumName,
        _albumListBloc = albumListBloc,
        super(ChangeAlbumNameInitial());

  Future<void> changeAlbumName({
    required String albumId,
    required String albumName,
  }) async {
    emit(ChangeAlbumNameLoading());
    final result = await _changeAlbumName(
      ChangeAlbumNameParams(albumId: albumId, newName: albumName),
    );
    result.fold(
      (failure) => emit(ChangeAlbumNameError(message: failure.message)),
      (_) {
        emit(ChangeAlbumNameSuccess(newAlbumName: albumName));
        _albumListBloc
            .add(ChangeAlbumNameEvent(albumId: albumId, albumName: albumName));
      },
    );
  }
}
