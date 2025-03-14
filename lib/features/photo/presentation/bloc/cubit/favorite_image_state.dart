part of 'favorite_image_cubit.dart';

@immutable
sealed class FavoriteImageState {}

final class FavoriteImageInitial extends FavoriteImageState {}

final class FavoriteImageSuccess extends FavoriteImageState {
  final String imageId;
  final bool isFavorite;

  FavoriteImageSuccess({required this.imageId, required this.isFavorite});
}

final class FavoriteImageError extends FavoriteImageState {
  final String message;

  FavoriteImageError({required this.message});
}
