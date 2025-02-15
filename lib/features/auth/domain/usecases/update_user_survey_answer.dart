import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:graduation_thesis_front_end/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/repositories/auth_repository.dart';

class UpdateUserSurveyAnswer
    implements UseCase<User, UpdateUserSurveyAnswerParams> {
  final AuthRepository authRepository;

  const UpdateUserSurveyAnswer(this.authRepository);

  @override
  Future<Either<Failure, User>> call(
      UpdateUserSurveyAnswerParams params) async {
    return await authRepository.updateUserSurveyAnswers(
        answers: params.answers, user: params.user);
  }
}

class UpdateUserSurveyAnswerParams {
  final List<String> answers;
  final User user;

  UpdateUserSurveyAnswerParams({required this.answers, required this.user});
}
