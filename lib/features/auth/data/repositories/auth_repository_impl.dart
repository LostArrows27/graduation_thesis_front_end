import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/common/entities/user.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:graduation_thesis_front_end/core/mock/data/fake_image_label.dart';
import 'package:graduation_thesis_front_end/features/auth/data/datasource/python/image_label_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/auth/data/datasource/supabase/auth_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/auth/data/datasource/supabase/image_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/auth/data/model/user_model.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ImageLabelRemoteDataSource imageLabelRemoteDataSource;
  final ImageRemoteDataSource imageRemoteDataSource;

  const AuthRepositoryImpl(
      {required this.remoteDataSource,
      required this.imageLabelRemoteDataSource,
      required this.imageRemoteDataSource});

  @override
  Future<Either<Failure, User>> loginWithEmailPassword(
      {required String email, required String password}) async {
    return _getUser(() async => await remoteDataSource
        .loginWithEmailAndPassword(email: email, password: password));
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    return _getUser(() async =>
        await remoteDataSource.signUpWithEmailAndPassword(
            name: name, email: email, password: password));
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      await fn();

      final userProfile = await remoteDataSource.getCurrentUserData();

      return right(userProfile!);
    } on sb.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final userData = await remoteDataSource.getCurrentUserData();

      if (userData == null) {
        return left(Failure('User is not logged in.'));
      }

      return right(userData);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> uploadAndUpdateUserAvatar(
      {required File image, required User user}) async {
    try {
      UserModel userModel = UserModel.fromUser(user);

      final avatarUrl = await remoteDataSource.uploadAvatarImage(
          image: image, userModel: userModel);

      final updatedUser = await remoteDataSource.updateUserProfileAvatar(
          userModel: userModel, avatarUrl: avatarUrl);
      return right(updatedUser);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserDobName(
      {required String dob, required String name, required User user}) async {
    try {
      UserModel userModel = UserModel.fromUser(user);

      final updatedUser = await remoteDataSource.updateUserDobAndName(
          userModel: userModel, dob: dob, name: name);

      return right(updatedUser);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserSurveyAnswers(
      {required List<String> answers, required User user}) async {
    try {
      UserModel userModel = UserModel.fromUser(user);

      final updatedUser = await remoteDataSource.updateUserSurveyAnswers(
          userModel: userModel, answers: answers);

      return right(updatedUser);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // image relate
  @override
  Future<Either<Failure, List<Photo>>> uploadAndLabelImage(
      {required List<File> images, required String userId}) async {
    try {
      final imageParams = await imageRemoteDataSource.uploadImageList(
          imageParams: images, userId: userId);

      // final imageParams = fakeImageParams;

      final imageModelList = await imageLabelRemoteDataSource.getLabelImages(
        imageParams: imageParams,
        userId: userId,
      );

      return right(imageModelList);

      // return right(imageListFake);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> markUserDoneLabeling(
      {required User user}) async {
    try {
      final updatedUser = await remoteDataSource.markUserDoneLabeling(
          userModel: UserModel.fromUser(user));

      return right(updatedUser);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
