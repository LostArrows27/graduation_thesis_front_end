import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:graduation_thesis_front_end/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/repositories/auth_repository.dart';

class UpdateUserDobName implements UseCase<User, UpdateUserDobNameParams> {
  final AuthRepository authRepository;

  const UpdateUserDobName(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UpdateUserDobNameParams params) async {
    return await authRepository.updateUserDobName(
        dob: params.dob, name: params.name, user: params.user);
  }
}

class UpdateUserDobNameParams {
  final String dob;
  final String name;
  final User user;

  UpdateUserDobNameParams(
      {required this.dob, required this.name, required this.user});
}
