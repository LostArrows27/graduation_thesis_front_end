part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

// success states
final class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess({required this.user});
}

final class AuthSignOutSuccess extends AuthState {}

// failure states
final class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});
}

final class AuthSignupFailure extends AuthFailure {
  AuthSignupFailure({required super.message});
}

final class AuthLoginFailure extends AuthFailure {
  AuthLoginFailure({required super.message});
}

// upload avatar
final class AuthAvatarUploading extends AuthState {}

final class AuthAvatarLoading extends AuthAvatarUploading {}

final class AuthAvatarUploadSuccess extends AuthAvatarUploading {}

final class AuthAvatarUploadFailure extends AuthFailure {
  AuthAvatarUploadFailure({required super.message});
}

// update user dob and name
final class AuthUpdateDobName extends AuthState {}

final class AuthUpdateDobNameLoading extends AuthUpdateDobName {}

final class AuthUpdateDobNameSuccess extends AuthUpdateDobName {}

final class AuthUpdateDobNameFailure extends AuthFailure {
  AuthUpdateDobNameFailure({required super.message});
}

// update user survey
final class AuthUpdateSurvey extends AuthState {}

final class AuthUpdateSurveyLoading extends AuthUpdateSurvey {}

final class AuthUpdateSurveySuccess extends AuthUpdateSurvey {}

final class AuthUpdateSurveyFailure extends AuthFailure {
  AuthUpdateSurveyFailure({required super.message});
}
