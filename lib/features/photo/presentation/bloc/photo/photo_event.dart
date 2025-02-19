part of 'photo_bloc.dart';

@immutable
sealed class PhotoEvent {}

final class PhotoFetchAllEvent extends PhotoEvent {
  final String userId;

  PhotoFetchAllEvent({required this.userId});
}
