import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:graduation_thesis_front_end/features/album/domain/entities/album.dart';
import 'package:graduation_thesis_front_end/features/album/domain/usecases/get_all_album.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';

part 'album_list_event.dart';
part 'album_list_state.dart';

class AlbumListBloc extends Bloc<AlbumListEvent, AlbumListState> {
  final GetAllAlbum _getAllAlbum;
  final PhotoBloc _photoBloc;
  final AppUserCubit _appUserCubit;
  late final StreamSubscription<PhotoState> _photoSubscription;

  AlbumListBloc(
      {required GetAllAlbum getAllAlbum,
      required PhotoBloc photoBloc,
      required AppUserCubit appUserCubit})
      : _getAllAlbum = getAllAlbum,
        _photoBloc = photoBloc,
        _appUserCubit = appUserCubit,
        super(AlbumListInitial()) {
    on<AlbumListEvent>((event, emit) {});

    on<GetAllAlbumEvent>(_getAllAlbumEvent);

    on<AddAlbumEvent>(_addAlbumEvent);

    on<ReloadAlbum>(_reloadAlbum);

    on<DeleteAlbumEvent>(_deleteAlbumEvent);

    on<ChangeAlbumNameEvent>(_changeAlbumNameEvent);

    _photoSubscription = _photoBloc.stream.listen((photoState) {
      if (photoState is PhotoFetchSuccess) {
        add(ReloadAlbum());
      }
    });
  }

  void _changeAlbumNameEvent(
      ChangeAlbumNameEvent event, Emitter<AlbumListState> emit) async {
    if (state is AlbumListLoaded) {
      final currentState = state as AlbumListLoaded;

      final album = currentState.albums
          .firstWhere((album) => album.id == event.albumId);

      final newAlbum = album.copyWith(name: event.albumName);

      final totalAlbums = currentState.albums
          .map((album) => album.id == event.albumId ? newAlbum : album)
          .toList();

      emit(AlbumListLoaded(albums: totalAlbums));
    }
  }

  void _deleteAlbumEvent(DeleteAlbumEvent event, Emitter<AlbumListState> emit) {
    if (state is AlbumListLoaded) {
      final currentState = state as AlbumListLoaded;

      final totalAlbums = currentState.albums
          .where((album) => album.id != event.albumId)
          .toList();

      emit(AlbumListLoaded(albums: totalAlbums));
    }
  }

  void _reloadAlbum(ReloadAlbum event, Emitter<AlbumListState> emit) {
    if (state is AlbumListInitial ||
        state is AlbumListLoading ||
        state is AlbumListError) {
      return;
    }

    List<Album> tempAlbums = [];

    final photoList = (_photoBloc.state as PhotoFetchSuccess).photos;

    final albums = (state as AlbumListLoaded).albums;

    for (var album in albums) {
      List<Photo> albumPhotos = [];
      List<String> imageIdList = album.imageIdList;
      for (var photo in photoList) {
        if (imageIdList.contains(photo.id)) {
          albumPhotos.add(photo);
        }
      }
      tempAlbums.add(album.copyWith(imageList: albumPhotos));
    }

    // NOTE: add profile picture album
    List<Photo> profilePhotos = photoList
        .where((photo) => photo.imageBucketId == 'user_profile')
        .toList();

    profilePhotos.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    Album profileAlbum = Album(
        id: 'profile_picture_album_id',
        ownerId: (_appUserCubit.state as AppUserLoggedIn).user.id,
        createdAt: profilePhotos.last.createdAt!,
        updatedAt: profilePhotos.first.updatedAt!,
        imageList: profilePhotos,
        imageIdList: profilePhotos.map((e) => e.imageUrl!).toList(),
        name: 'Profile');

    tempAlbums.add(profileAlbum);

    // NOTE: add favorite album
    List<Photo> favoritePhotos =
        photoList.where((photo) => photo.isFavorite == true).toList();

    favoritePhotos.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    if (favoritePhotos.isNotEmpty) {
      Album favoriteAlbum = Album(
          id: 'favorite_album_id',
          ownerId: (_appUserCubit.state as AppUserLoggedIn).user.id,
          createdAt: favoritePhotos.last.createdAt!,
          updatedAt: favoritePhotos.first.updatedAt!,
          imageList: favoritePhotos,
          imageIdList: favoritePhotos.map((e) => e.imageUrl!).toList(),
          name: 'Favorite');

      tempAlbums.add(favoriteAlbum);
    }

    emit(AlbumListLoaded(albums: tempAlbums));
  }

  void _getAllAlbumEvent(
      GetAllAlbumEvent event, Emitter<AlbumListState> emit) async {
    emit(AlbumListLoading());
    final result = await _getAllAlbum(NoParams());
    result.fold(
      (failure) => emit(AlbumListError(message: failure.message)),
      (albums) {
        if (_photoBloc.state is! PhotoFetchSuccess) {
          emit(AlbumListLoaded(albums: albums));
        } else {
          List<Album> tempAlbums = [];

          final photoList = (_photoBloc.state as PhotoFetchSuccess).photos;

          for (var album in albums) {
            List<Photo> albumPhotos = [];
            List<String> imageIdList = album.imageIdList;
            for (var photo in photoList) {
              if (imageIdList.contains(photo.id)) {
                albumPhotos.add(photo);
              }
            }
            tempAlbums.add(album.copyWith(imageList: albumPhotos));
          }

          List<Photo> profilePhotos = photoList
              .where((photo) => photo.imageBucketId == 'user_profile')
              .toList();

          profilePhotos.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

          Album profileAlbum = Album(
              id: 'profile_picture_album_id',
              ownerId: (_appUserCubit.state as AppUserLoggedIn).user.id,
              createdAt: profilePhotos.last.createdAt!,
              updatedAt: profilePhotos.first.updatedAt!,
              imageList: profilePhotos,
              imageIdList: profilePhotos.map((e) => e.imageUrl!).toList(),
              name: 'Profile');

          tempAlbums.add(profileAlbum);

          // NOTE: add favorite album
          List<Photo> favoritePhotos =
              photoList.where((photo) => photo.isFavorite == true).toList();

          favoritePhotos.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

          if (favoritePhotos.isNotEmpty) {
            Album favoriteAlbum = Album(
                id: 'favorite_album_id',
                ownerId: (_appUserCubit.state as AppUserLoggedIn).user.id,
                createdAt: favoritePhotos.last.createdAt!,
                updatedAt: favoritePhotos.first.updatedAt!,
                imageList: favoritePhotos,
                imageIdList: favoritePhotos.map((e) => e.imageUrl!).toList(),
                name: 'Favorite');

            tempAlbums.add(favoriteAlbum);
          }

          emit(AlbumListLoaded(albums: tempAlbums));
        }
      },
    );
  }

  void _addAlbumEvent(AddAlbumEvent event, Emitter<AlbumListState> emit) {
    if (state is AlbumListLoaded) {
      final currentState = state as AlbumListLoaded;

      final photoList = (_photoBloc.state as PhotoFetchSuccess).photos;
      List<Photo> albumPhotos = [];

      for (var photo in photoList) {
        if (event.album.imageIdList.contains(photo.id)) {
          albumPhotos.add(photo);
        }
      }

      final totalAlbums = [
        ...currentState.albums,
        event.album.copyWith(imageList: albumPhotos)
      ];
      emit(AlbumListLoaded(albums: totalAlbums));
    } else {
      emit(AlbumListLoaded(albums: [event.album]));
    }
  }

  @override
  Future<void> close() {
    _photoSubscription.cancel();
    return super.close();
  }
}
