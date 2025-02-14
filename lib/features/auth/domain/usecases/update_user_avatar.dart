import 'dart:io';

import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:graduation_thesis_front_end/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/repositories/auth_repository.dart';

class UpdateUserAvatar implements UseCase<User, UploadUserAvatarParams> {
  final AuthRepository authRepository;

  const UpdateUserAvatar(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UploadUserAvatarParams params) async {
    return await authRepository.uploadAndUpdateUserAvatar(
        image: params.image, user: params.user);
  }
}

class UploadUserAvatarParams {
  final File image;
  final User user;

  UploadUserAvatarParams({required this.image, required this.user});
}
