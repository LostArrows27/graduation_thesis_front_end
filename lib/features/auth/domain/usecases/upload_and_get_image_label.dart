import 'dart:io';

import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/repositories/auth_repository.dart';

class UploadAndGetImageLabel
    implements UseCase<List<Image>, UploadAndGetImageLabelParams> {
  final AuthRepository authRepository;

  const UploadAndGetImageLabel(this.authRepository);

  @override
  Future<Either<Failure, List<Image>>> call(
      UploadAndGetImageLabelParams params) async {
    return await authRepository.uploadAndLabelImage(
        images: params.images, userId: params.userId);
  }
}

class UploadAndGetImageLabelParams {
  final List<File> images;
  final String userId;

  UploadAndGetImageLabelParams({required this.images, required this.userId});
}
