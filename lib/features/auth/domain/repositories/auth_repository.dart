import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/core/common/entities/user.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, User>> uploadAndUpdateUserAvatar({
    required File image,
    required User user,
  });

  Future<Either<Failure, User>> updateUserDobName({
    required String dob,
    required String name,
    required User user,
  });
}
