import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:graduation_thesis_front_end/core/common/entities/user.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/usecases/current_user.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/usecases/update_user_avatar.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/usecases/update_user_dob_name.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/usecases/user_login.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/usecases/user_sign_out.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignup _userSignUp;
  final UserSignOut _userSignOut;
  final UserLogin _userLogin;
  final AppUserCubit _appUserCubit;
  final CurrentUser _currentUser;
  final UpdateUserAvatar _updateUserAvatar;
  final UpdateUserDobName _updateUserDobName;

  AuthBloc(
      {required UserSignup userSignup,
      required UserSignOut userSignOut,
      required UserLogin userLogin,
      required CurrentUser currentUser,
      required UpdateUserAvatar updateUserAvatar,
      required UpdateUserDobName updateUserDobName,
      required AppUserCubit appUserCubit})
      : _userSignUp = userSignup,
        _userSignOut = userSignOut,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _updateUserAvatar = updateUserAvatar,
        _appUserCubit = appUserCubit,
        _updateUserDobName = updateUserDobName,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) {
      if (AuthEvent is! AuthUploadProfilePicture) {
        emit(AuthLoading());
      }
    });
    on<AuthSignup>(_onAuthSignup);
    on<AuthIsUserLoggedIn>(_onAuthIsUserLoggedIn);
    on<AuthSignOut>(_onAuthSignOut);
    on<AuthLogin>(_onAuthLogin);
    on<AuthUploadProfilePicture>(_onAuthUploadProfilePicture);
    on<AuthUpdateUserDobNameEvent>(_onAuthUpdateUserDobNameHandle);
  }

  void _onAuthSignup(AuthSignup event, Emitter<AuthState> emit) async {
    final res = await _userSignUp(UserSignupParams(
        name: event.name, email: event.email, password: event.password));

    res.fold((l) => emit(AuthSignupFailure(message: l.message)),
        (r) => _emitAuthSuccess(r, emit));
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final res = await _userLogin(
        UserLoginParams(email: event.email, password: event.password));

    res.fold((l) => emit(AuthLoginFailure(message: l.message)),
        (r) => _emitAuthSuccess(r, emit));
  }

  void _onAuthIsUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _currentUser(NoParams());

    res.fold((l) => emit(AuthFailure(message: l.message)),
        (user) => _emitAuthSuccess(user, emit));
  }

  void _onAuthSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    // NOTE: emit(AuthLoading());
    _appUserCubit.updateUser(null);

    final res = await _userSignOut(NoParams());

    res.fold((l) => emit(AuthFailure(message: l.message)),
        (r) => emit(AuthSignOutSuccess()));
  }

  void _onAuthUploadProfilePicture(
      AuthUploadProfilePicture event, Emitter<AuthState> emit) async {
    emit(AuthAvatarLoading());
    final res = await _updateUserAvatar(
        UploadUserAvatarParams(image: event.file, user: event.user));

    res.fold((l) => emit(AuthAvatarUploadFailure(message: l.message)), (r) {
      _appUserCubit.updateUser(r);
      emit(AuthAvatarUploadSuccess());
    });
  }

  void _onAuthUpdateUserDobNameHandle(
      AuthUpdateUserDobNameEvent event, Emitter<AuthState> emit) async {
    emit(AuthUpdateDobNameLoading());
    final res = await _updateUserDobName(UpdateUserDobNameParams(
        user: event.user, dob: event.dob, name: event.name));

    res.fold((l) => emit(AuthUpdateDobNameFailure(message: l.message)), (r) {
      _appUserCubit.updateUser(r);
      emit(AuthUpdateDobNameSuccess());
    });
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}
