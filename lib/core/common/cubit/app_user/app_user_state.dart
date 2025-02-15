part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {
  final User user;

  AppUserLoggedIn({required this.user});
}

// missing -> dob, avatar
final class AppUserWithMissingInfo extends AppUserState {
  final User user;

  AppUserWithMissingInfo({required this.user});
}

// missing -> dob
final class AppUserWithMissingDob extends AppUserState {
  final User user;

  AppUserWithMissingDob({required this.user});
}

// missing -> survey forms
final class AppUserWithMissingSurvey extends AppUserState {
  final User user;

  AppUserWithMissingSurvey({required this.user});
}
