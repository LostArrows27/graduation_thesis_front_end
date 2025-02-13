import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/landing_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/login_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/sign_up_page.dart';

final routerConfig = GoRouter(
  initialLocation: '/landing-page',
  routes: [
    GoRoute(
      path: '/landing-page',
      name: 'LandingPage',
      builder: (context, state) => const LandingPage(),
    ),
    GoRoute(
      path: '/login',
      name: 'LoginPage',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/sign-up',
      name: 'SignUpPage',
      builder: (context, state) => const SignUpPage(),
    ),
  ],
);