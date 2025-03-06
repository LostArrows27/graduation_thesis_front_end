import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:graduation_thesis_front_end/core/routes/router.dependencies.dart';
import 'package:graduation_thesis_front_end/core/theme/app_theme.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/bloc/person_group/person_group_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/cubit/photo_view_mode_cubit.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';
import 'package:graduation_thesis_front_end/init_dependencies.dart';
// import 'package:media_kit/media_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // MediaKit.ensureInitialized();

  await initDependencies();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
      BlocProvider(create: (_) => serviceLocator<PhotoBloc>()),
      BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
      BlocProvider(create: (_) => serviceLocator<PhotoViewModeCubit>()),
      BlocProvider(create: (_) => serviceLocator<PersonGroupBloc>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Smart Gallery',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: routerConfig);
  }
}
