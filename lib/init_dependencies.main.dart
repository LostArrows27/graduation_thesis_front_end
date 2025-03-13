part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initPhoto();
  _initVideoRender();
  _initExplore();
  _initAlbum();
  _initSearch();

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
        () => ImageLabelRemoteDataSourceImpl(supabaseClient: serviceLocator()))
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
        photoBloc: serviceLocator(),
        photoViewModeCubit: serviceLocator(),
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
    ..registerFactory(() => UploadImages(authRepository: serviceLocator()))
    ..registerFactory(() => EditImageCaption(photoRepository: serviceLocator()))
    ..registerFactory(() => DeleteImage(photoRepository: serviceLocator()))
    // bloc
    ..registerLazySingleton(() => PhotoBloc(getAllUserImage: serviceLocator()))
    ..registerFactory(() => UploadPhotoBloc(uploadImages: serviceLocator()))
    ..registerLazySingleton(() => EditCaptionBloc(
        photoBloc: serviceLocator(), editImageCaption: serviceLocator()))
    // cubit
    ..registerLazySingleton(() => PhotoViewModeCubit())
    ..registerLazySingleton(() => DeleteImageCubit(
        deleteImage: serviceLocator(), photoBloc: serviceLocator()));
}

void _initVideoRender() {
  serviceLocator
    // data source
    ..registerFactory<VideoRenderRemoteDatasource>(
        () => VideoRenderRemoteDatasourceImpl(supabaseClient: serviceLocator()))
    ..registerFactory<VideoRenderDatasource>(
        () => VideoRenderDatasourceImpl(supabaseClient: serviceLocator()))
    // repository
    ..registerFactory<VideoRenderRepository>(() => VideoRenderRepositoryImpl(
        imageRemoteDataSource: serviceLocator(),
        imageLabelRemoteDataSource: serviceLocator(),
        videoRenderSupabaseDatasource: serviceLocator(),
        videoRenderNodeJsDatasource: serviceLocator()))
    // use case
    ..registerFactory(
        () => GetVideoSchema(videoRenderRepository: serviceLocator()))
    ..registerFactory(
        () => EditVideoSchema(videoRenderRepository: serviceLocator()))
    ..registerFactory(
        () => GetAllVideoRender(videoRenderRepository: serviceLocator()))
    ..registerFactory(
        () => GetAllVideoChunk(videoRenderRepository: serviceLocator()))
    // bloc
    ..registerLazySingleton(
        () => VideoRenderSchemaBloc(getVideoSchema: serviceLocator()))
    ..registerLazySingleton(
        () => EditVideoSchemaBloc(editVideoSchema: serviceLocator()))
    ..registerLazySingleton(
        () => VideoRenderProgressBloc(videoRenderRepository: serviceLocator()))
    ..registerLazySingleton(() => RenderStatusBloc(
        videoRenderRepository: serviceLocator(),
        getAllVideoRender: serviceLocator()))
    ..registerLazySingleton(
        () => VideoChunkBloc(getAllVideoChunk: serviceLocator()));
}

void _initExplore() {
  serviceLocator
    // data source
    ..registerFactory<PeopleCategoryRemoteDatasource>(() =>
        PeopleCategoryRemoteDatasourceImpl(supabaseClient: serviceLocator()))
    ..registerFactory<PersonGroupRemoteDatasource>(
        () => PersonGroupRemoteDatasourceImpl(supabaseClient: serviceLocator()))
    // repository
    ..registerFactory<ExploreRepository>(() => ExploreRepositoryImpl(
        personGroupRemoteDatasource: serviceLocator(),
        peopleCategoryRemoteDatasource: serviceLocator()))
    // use case
    ..registerFactory(() => GetPeopleGroup(exploreRepository: serviceLocator()))
    ..registerFactory(
        () => ChangePersonGroupName(exploreRepository: serviceLocator()))
    // bloc
    ..registerLazySingleton(() => PersonGroupBloc(
        photoBloc: serviceLocator(),
        changePersonGroupName: serviceLocator(),
        getPeopleGroup: serviceLocator()));
}

void _initAlbum() {
  serviceLocator
    // data source
    ..registerFactory<AlbumRemoteDatasource>(
        () => AlbumRemoteDatasourceImpl(supabaseClient: serviceLocator()))
    // repository
    ..registerFactory<AlbumRepository>(
        () => AlbumRepositoryImpl(albumRemoteDatasource: serviceLocator()))
    // use case
    ..registerFactory(() => CreateAlbum(albumRepository: serviceLocator()))
    ..registerFactory(() => GetAllAlbum(albumRepository: serviceLocator()))
    // bloc
    ..registerFactory(() => AlbumBloc(createAlbum: serviceLocator()))
    ..registerLazySingleton(() => AlbumListBloc(
        appUserCubit: serviceLocator(),
        photoBloc: serviceLocator(),
        getAllAlbum: serviceLocator()))
    // cubit
    ..registerFactory(() => ChooseImageModeCubit());
}

void _initSearch() {
  serviceLocator
    // data source
    ..registerFactory<SearchHistoryRemoteDatasource>(() =>
        SearchHistoryRemoteDatasourceImpl(supabaseClient: serviceLocator()))
    ..registerFactory<SearchHistorySupabaseDatasource>(() =>
        SearchHistorySupabaseDatasourceImpl(supabaseClient: serviceLocator()))
    // repository
    ..registerFactory<SearchRepository>(() => SearchRepositoryImpl(
        searchHistorySupabaseDatasource: serviceLocator(),
        searchHistoryRemoteDatasource: serviceLocator()))
    // use case
    ..registerFactory(
        () => QueryImageByText(searchRepository: serviceLocator()))
    ..registerFactory(
        () => GetAllSearchHistory(searchRepository: serviceLocator()))
    ..registerFactory(
        () => DeleteSearchHistory(searchRepository: serviceLocator()))
    ..registerFactory(
        () => AddSearchHistory(searchRepository: serviceLocator()))
    // bloc
    ..registerFactory(
        () => SearchHistoryBloc(queryImageByText: serviceLocator()))
    ..registerLazySingleton(() => SearchHistoryListenBloc(
        addSearchHistory: serviceLocator(),
        deleteSearchHistory: serviceLocator(),
        getAllSearchHistory: serviceLocator(),
        searchRepository: serviceLocator()));
}
