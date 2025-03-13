part of 'delete_image_cubit.dart';

@immutable
sealed class DeleteImageCubitState {}

final class DeleteImageCubitInitial extends DeleteImageCubitState {}

final class DeleteImageCubitLoading extends DeleteImageCubitState {}

final class DeleteImageCubitSuccess extends DeleteImageCubitState {
  final String imageBucketId;
  final String imageName;

  DeleteImageCubitSuccess(
      {required this.imageBucketId, required this.imageName});
}

final class DeleteImageCubitError extends DeleteImageCubitState {
  final String message;

  DeleteImageCubitError({required this.message});
}
