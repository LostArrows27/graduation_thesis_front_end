import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/common/entities/user.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(User? user) {
    if (user == null) {
      emit(AppUserInitial());
    } else if (user.avatarUrl == null || user.avatarUrl!.isEmpty) {
      emit(AppUserWithMissingInfo(user: user));
    } else if (user.dob == null) {
      emit(AppUserWithMissingDob(user: user));
    } else if (user.surveyAnswers == null) {
      emit(AppUserWithMissingSurvey(user: user));
    } else if (user.isDoneLabelForm == false) {
      emit(AppUserWithMissingLabel(user: user));
    } else {
      emit(AppUserLoggedIn(user: user));
    }
  }
}
