import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:graduation_thesis_front_end/core/common/entities/user.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:graduation_thesis_front_end/features/auth/domain/usecases/current_user.dart';
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

  AuthBloc(
      {required UserSignup userSignup,
      required UserSignOut userSignOut,
      required UserLogin userLogin,
      required CurrentUser currentUser,
      required AppUserCubit appUserCubit})
      : _userSignUp = userSignup,
        _userSignOut = userSignOut,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) {
      emit(AuthLoading());
    });
    on<AuthSignup>(_onAuthSignup);
    on<AuthIsUserLoggedIn>(_onAuthIsUserLoggedIn);
    on<AuthSignOut>(_onAuthSignOut);
    on<AuthLogin>(_onAuthLogin);
  }

  void _onAuthSignup(AuthSignup event, Emitter<AuthState> emit) async {
    final res = await _userSignUp(UserSignupParams(
        name: event.name, email: event.email, password: event.password));

    res.fold((l) => emit(AuthFailure(message: l.message)),
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

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final res = await _userLogin(
        UserLoginParams(email: event.email, password: event.password));

    res.fold((l) => emit(AuthFailure(message: l.message)),
        (r) => _emitAuthSuccess(r, emit));
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}
