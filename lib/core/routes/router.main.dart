part of 'router.dependencies.dart';

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
            HomeScaffoldLayout(navigationShell: navigationShell),
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
        ]),
    // video render route
    GoRoute(
        path: Routes.videoRenderStatusPage,
        builder: (context, state) => const VideoRenderStatusPage()),
    GoRoute(
        path: Routes.videoImagePickerPage,
        builder: (context, state) => const VideoImagePickerPage()),

    GoRoute(
        path: Routes.editVideoSchemaPage,
        builder: (context, state) {
          var videoSchema = state.extra as VideoSchema;
          return EditVideoSchemaPage(videoSchema: videoSchema);
        }),
    GoRoute(
        path: Routes.videoRenderResult,
        builder: (context, state) {
          var videoRenderId = state.extra as String;
          return VideoRenderResultPage(videoRenderId: videoRenderId);
        }),
    GoRoute(
        path: Routes.videoViewerPage,
        builder: (context, state) {
          var videoRenderId = state.extra as String;
          return VideoViewer(videoRenderId: videoRenderId);
        })
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
