part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignup extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthSignup({required this.name, required this.email, required this.password});
}

final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({required this.email, required this.password});
}

final class AuthIsUserLoggedIn extends AuthEvent {}

final class AuthSignOut extends AuthEvent {}

final class AuthUploadProfilePicture extends AuthEvent {
  final File file;
  final User user;

  AuthUploadProfilePicture({required this.file, required this.user});
}

final class AuthUpdateUserDobNameEvent extends AuthEvent {
  final String name;
  final String dob;
  final User user;

  AuthUpdateUserDobNameEvent(
      {required this.name, required this.dob, required this.user});
}

final class AuthUpdateUserSurveyEvent extends AuthEvent {
  final List<String> answers;
  final User user;

  AuthUpdateUserSurveyEvent({required this.answers, required this.user});
}

// upload and label image
final class UploadAndGetImageLabelEvent extends AuthEvent {
  final List<File> files;

  UploadAndGetImageLabelEvent({required this.files});
}

final class AuthMarkDoneLabelingEvent extends AuthEvent {
  final User user;

  AuthMarkDoneLabelingEvent({required this.user});
}
