import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:graduation_thesis_front_end/features/album/domain/entities/album.dart';
import 'package:graduation_thesis_front_end/features/album/domain/usecases/get_all_album.dart';

part 'album_list_event.dart';
part 'album_list_state.dart';

class AlbumListBloc extends Bloc<AlbumListEvent, AlbumListState> {
  final GetAllAlbum _getAllAlbum;

  AlbumListBloc({required GetAllAlbum getAllAlbum})
      : _getAllAlbum = getAllAlbum,
        super(AlbumListInitial()) {
    on<AlbumListEvent>((event, emit) {});

    on<GetAllAlbumEvent>(_getAllAlbumEvent);

    on<AddAlbumEvent>(_addAlbumEvent);
  }

  void _getAllAlbumEvent(
      GetAllAlbumEvent event, Emitter<AlbumListState> emit) async {
    emit(AlbumListLoading());
    final result = await _getAllAlbum(NoParams());
    result.fold(
      (failure) => emit(AlbumListError(message: failure.message)),
      (albums) => emit(AlbumListLoaded(albums: albums)),
    );
  }

  void _addAlbumEvent(AddAlbumEvent event, Emitter<AlbumListState> emit) {
    if (state is AlbumListLoaded) {
      final currentState = state as AlbumListLoaded;
      final totalAlbums = [...currentState.albums, event.album];
      emit(AlbumListLoaded(albums: totalAlbums));
    } else {
      emit(AlbumListLoaded(albums: [event.album]));
    }
  }
}
