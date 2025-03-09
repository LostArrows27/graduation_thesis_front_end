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
        }),
    // explore route
    GoRoute(
        path: Routes.peopleExplorePage,
        builder: (context, state) {
          final personGroups = state.extra as List<PersonGroup>;
          return ExplorePeoplePage(peopleList: personGroups);
        }),
    GoRoute(
        path: Routes.peopleDetailPage,
        builder: (context, state) {
          final personGroup = state.extra as PersonGroup;
          return PeopleDetail(personGroup: personGroup);
        }),
    // photo route
    GoRoute(
        path: Routes.uploadPhotoPage,
        builder: (context, state) {
          final imageFiles = state.extra as List<File>;
          return UploadPhotoPage(imageFiles: imageFiles);
        }),
    GoRoute(
      path: Routes.imageSliderPage,
      pageBuilder: (context, state) {
        final object = state.extra as Map<String, dynamic>;
        return CustomTransitionPage(
          key: state.pageKey,
          child: ImageSliderPage(
            url: object['url'] as String,
            images: object['images'] as List<Photo>,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child; // No animation, just show the page
          },
          opaque: false, // This makes the route transparent
          barrierDismissible: false,
        );
      },
    ),
    // test route
    GoRoute(
      path: Routes.photoViewDemo,
      builder: (context, state) => const SimplePhotoViewDemo(),
    ),
    GoRoute(
      path: Routes.photoSliderDemo,
      builder: (context, state) {
        final object = state.extra as Map<String, dynamic>;
        return SimplePicsWiper(
          images: object['images'] as List<String>,
          url: object['url'] as String,
        );
      },
    )
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
