part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
      url: AppSecret.supabaseUrl, anonKey: AppSecret.supabaseAnonKey);

  // 1 instance everytime called
  serviceLocator.registerLazySingleton<SupabaseClient>(() => supabase.client);

  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  // new instance everytime called
  serviceLocator
    // data source
    ..registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(serviceLocator()))
    // repository
    ..registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(serviceLocator()))
    // use case
    ..registerFactory(() => UserSignup(serviceLocator()))
    ..registerFactory(() => UserSignOut(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerFactory(() => UpdateUserAvatar(serviceLocator()))
    // bloc
    ..registerLazySingleton(() => AuthBloc(
        userSignup: serviceLocator(),
        userSignOut: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        updateUserAvatar: serviceLocator(),
        appUserCubit: serviceLocator()));
}
