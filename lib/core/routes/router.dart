import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:graduation_thesis_front_end/core/routes/go_router_refresh_stream.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/basic-information/confirm_done_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/basic-information/dob_name_form_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/basic-information/survey_form_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/basic-information/upload_avatar_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/basic-information/upload_image_label_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/landing_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/login_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/sign_up_page.dart';
import 'package:graduation_thesis_front_end/home.dart';
import 'package:graduation_thesis_front_end/init_dependencies.dart';

final routerConfig = GoRouter(
  initialLocation: LandingPage.path,
  routes: [
    // auth route
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
    // information page
    GoRoute(
        path: UploadAvatarPage.path,
        builder: (context, state) => const UploadAvatarPage()),

    GoRoute(
        path: DobNameFormPage.path,
        builder: (context, state) => const DobNameFormPage()),

    GoRoute(
        path: SurveyFormPage.path,
        builder: (context, state) => SurveyFormPage()),

    GoRoute(
        path: UploadImageLabel.path,
        builder: (context, state) => const UploadImageLabel()),
    GoRoute(
        path: ConfirmDonePage.path,
        builder: (context, state) => const ConfirmDonePage()),
    // home route
    GoRoute(
        path: HomePageFake.path,
        builder: (context, state) => const HomePageFake()),
  ],
  redirect: (context, state) {
    final appUserCubit = BlocProvider.of<AppUserCubit>(context);
    final authState = appUserCubit.state;

    print(authState);

    // check app user state
    if (authState is AppUserWithMissingInfo) {
      return UploadAvatarPage.path;
    }

    if (authState is AppUserWithMissingDob) {
      return DobNameFormPage.path;
    }

    if (authState is AppUserWithMissingSurvey) {
      return SurveyFormPage.path;
    }

    if (authState is AppUserWithMissingLabel) {
      return UploadImageLabel.path;
    }

    // check if user in confirming page (redirect after done labeling)
    if (state.fullPath == ConfirmDonePage.path) {
      return null;
    }

    if (authState is AppUserLoggedIn) {
      return HomePageFake.path;
    }

    // check current page
    final isLoggingIn =
        state.fullPath == LoginPage.path || state.fullPath == SignUpPage.path;

    if (isLoggingIn) {
      return null;
    }

    return LandingPage.path;
  },
  refreshListenable: GoRouterRefreshStream(serviceLocator<AuthBloc>().stream),
);
