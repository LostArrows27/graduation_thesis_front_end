import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:graduation_thesis_front_end/core/routes/go_router_refresh_stream.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/landing_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/login_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/sign_up_page.dart';
import 'package:graduation_thesis_front_end/home.dart';
import 'package:graduation_thesis_front_end/init_dependencies.dart';

final routerConfig = GoRouter(
  initialLocation: LandingPage.path,
  routes: [
    GoRoute(
      path: LandingPage.path,
      builder: (context, state) => const LandingPage(),
    ),
    GoRoute(
      path: LoginPage.path,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: SignUpPage.path,
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
        path: HomePageFake.path,
        builder: (context, state) => const HomePageFake()),
  ],
  redirect: (context, state) {
    final appUserCubit = BlocProvider.of<AppUserCubit>(context);
    final isLoggedIn = appUserCubit.state is AppUserLoggedIn;

    if (isLoggedIn) {
      final user = (appUserCubit.state as AppUserLoggedIn).user;
      log(user.email);
    }

    final isLoggingIn =
        state.fullPath == LoginPage.path || state.fullPath == SignUpPage.path;

    if (isLoggedIn) {
      return HomePageFake.path;
    }

    if (isLoggingIn) {
      return null;
    }

    return LandingPage.path;
  },
  refreshListenable: GoRouterRefreshStream(serviceLocator<AuthBloc>().stream),
);
