import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/core/common/entities/user.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:graduation_thesis_front_end/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/auth/data/model/user_model.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl(this.remoteDataSource);

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
      final user = await fn();

      return right(user);
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
}
