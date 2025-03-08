import 'dart:io';

import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/repositories/auth_repository.dart';

class UploadImages implements UseCase<List<Photo>, UploadImagesParams> {
  final AuthRepository authRepository;

  const UploadImages({required this.authRepository});

  @override
  Future<Either<Failure, List<Photo>>> call(UploadImagesParams params) async {
    return await authRepository.uploadAndLabelImage(images: params.images);
  }
}

class UploadImagesParams {
  final List<File> images;

  UploadImagesParams({required this.images});
}
