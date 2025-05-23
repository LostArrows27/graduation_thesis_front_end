import 'dart:io';

import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/repositories/auth_repository.dart';

class UploadAndGetImageLabel
    implements UseCase<List<Photo>, UploadAndGetImageLabelParams> {
  final AuthRepository authRepository;

  const UploadAndGetImageLabel(this.authRepository);

  @override
  Future<Either<Failure, List<Photo>>> call(
      UploadAndGetImageLabelParams params) async {
    return await authRepository.uploadAndLabelImage(images: params.images);
  }
}

class UploadAndGetImageLabelParams {
  final List<File> images;

  UploadAndGetImageLabelParams({required this.images});
}
