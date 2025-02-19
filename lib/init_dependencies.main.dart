part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initPhoto();
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
    ..registerFactory<ImageRemoteDataSource>(
        () => ImageRemoteDataSourceImpl(supabaseClient: serviceLocator()))
    ..registerFactory<ImageLabelRemoteDataSource>(
        () => ImageLabelRemoteDataSourceImpl())
    // repository
    ..registerFactory<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: serviceLocator(),
        imageLabelRemoteDataSource: serviceLocator(),
        imageRemoteDataSource: serviceLocator()))
    // use case
    ..registerFactory(() => UserSignup(serviceLocator()))
    ..registerFactory(() => UserSignOut(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerFactory(() => UpdateUserAvatar(serviceLocator()))
    ..registerFactory(() => UpdateUserDobName(serviceLocator()))
    ..registerFactory(() => UpdateUserSurveyAnswer(serviceLocator()))
    ..registerFactory(() => UploadAndGetImageLabel(serviceLocator()))
    ..registerFactory(() => MarkUserDoneLabeling(serviceLocator()))
    // bloc
    ..registerLazySingleton(() => AuthBloc(
        userSignup: serviceLocator(),
        userSignOut: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        updateUserAvatar: serviceLocator(),
        updateUserDobName: serviceLocator(),
        updateUserSurveyAnswer: serviceLocator(),
        uploadAndGetImageLabel: serviceLocator(),
        markUserDoneLabeling: serviceLocator(),
        appUserCubit: serviceLocator()));
}

void _initPhoto() {
  serviceLocator
    // data source
    ..registerFactory<PhotoRemoteDataSource>(
        () => PhotoRemoteDataSourceImpl(supabaseClient: serviceLocator()))
    // repository
    ..registerFactory<PhotoRepository>(
        () => PhotoRepositoryImpl(photoRemoteDataSource: serviceLocator()))
    // use case
    ..registerFactory(() => GetAllUserImage(serviceLocator()))
    // bloc
    ..registerLazySingleton(() => PhotoBloc(getAllUserImage: serviceLocator()))
    // cubit
    ..registerLazySingleton(() => PhotoViewModeCubit());
}
