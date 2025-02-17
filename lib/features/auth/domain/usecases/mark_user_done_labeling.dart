import 'package:graduation_thesis_front_end/core/common/entities/user.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/repositories/auth_repository.dart';

class MarkUserDoneLabeling
    implements UseCase<void, MarkUserDoneLabelingParams> {
  final AuthRepository authRepository;

  const MarkUserDoneLabeling(this.authRepository);

  @override
  Future<Either<Failure, User>> call(MarkUserDoneLabelingParams params) async {
    return await authRepository.markUserDoneLabeling(user: params.user);
  }
}

class MarkUserDoneLabelingParams {
  final User user;

  MarkUserDoneLabelingParams({required this.user});
}
