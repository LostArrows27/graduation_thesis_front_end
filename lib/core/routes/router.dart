import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:graduation_thesis_front_end/core/common/layout/layout_scaffold.dart';
import 'package:graduation_thesis_front_end/core/fake_page/album_page.dart';
import 'package:graduation_thesis_front_end/core/fake_page/explore_page.dart';
import 'package:graduation_thesis_front_end/core/fake_page/search_page.dart';
import 'package:graduation_thesis_front_end/core/routes/go_router_refresh_stream.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/basic-information/confirm_done_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/basic-information/dob_name_form_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/basic-information/survey_form_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/basic-information/upload_avatar_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/basic-information/upload_image_label_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/landing_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/login_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/sign_up_page.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/pages/photo_page.dart';
import 'package:graduation_thesis_front_end/init_dependencies.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final routerConfig = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.landingPage,
  routes: [
    // auth route
    GoRoute(
      path: Routes.landingPage,
      builder: (context, state) => const LandingPage(),
    ),
    GoRoute(
      path: Routes.loginPage,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: Routes.signUpPage,
      builder: (context, state) => const SignUpPage(),
    ),
    // information page
    GoRoute(
        path: Routes.uploadAvatarPage,
        builder: (context, state) => const UploadAvatarPage()),

    GoRoute(
        path: Routes.dobNameFormPage,
        builder: (context, state) => const DobNameFormPage()),

    GoRoute(
        path: Routes.surveyFormPage,
        builder: (context, state) => SurveyFormPage()),

    GoRoute(
        path: Routes.uploadImageLabelPage,
        builder: (context, state) => const UploadImageLabel()),
    GoRoute(
        path: Routes.confirmDonePage,
        builder: (context, state) => const ConfirmDonePage()),
    // home route
    StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            LayoutScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
                path: Routes.photosPage,
                builder: (context, state) => const PhotoPage())
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: Routes.albumsPage,
                builder: (context, state) => const AlbumPageFake())
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: Routes.explorePage,
                builder: (context, state) => const ExplorePageFake())
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: Routes.searchPage,
                builder: (context, state) => const SearchPageFake())
          ]),
        ])
  ],
  redirect: (context, state) {
    final appUserCubit = BlocProvider.of<AppUserCubit>(context);
    final authState = appUserCubit.state;

    if (authState is AppUserLoggedIn) {
      if (homeRouteList.contains(state.fullPath)) {
        return null;
      } else {
        return Routes.photosPage;
      }
    }

    // check app user state
    if (authState is AppUserWithMissingInfo) {
      return Routes.uploadAvatarPage;
    }

    if (authState is AppUserWithMissingDob) {
      return Routes.dobNameFormPage;
    }

    if (authState is AppUserWithMissingSurvey) {
      return Routes.surveyFormPage;
    }

    if (authState is AppUserWithMissingLabel) {
      return Routes.uploadImageLabelPage;
    }

    // check if user in confirming page (redirect after done labeling)
    if (state.fullPath == Routes.confirmDonePage) {
      return null;
    }

    // check current page
    final isLoggingIn = state.fullPath == Routes.loginPage ||
        state.fullPath == Routes.signUpPage;

    if (isLoggingIn) {
      return null;
    }

    return Routes.landingPage;
  },
  refreshListenable: GoRouterRefreshStream(serviceLocator<AuthBloc>().stream),
);
