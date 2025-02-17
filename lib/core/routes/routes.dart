class Routes {
  Routes._();
  // auth route
  static const String landingPage = '/landing-page';
  static const String loginPage = '/login';
  static const String signUpPage = '/sign-up';

  // basic information route
  static const String uploadAvatarPage = '/information/upload-avatar';
  static const String dobNameFormPage = '/information/dob-name-form';
  static const String surveyFormPage = '/information/survey-form';
  static const String uploadImageLabelPage = '/information/upload-image-label';
  static const String confirmDonePage = '/information/confirm-done';

  // home route
  static const String photosPage = '/photos';
  static const String albumsPage = '/albums';
  static const String explorePage = '/explore';
  static const String searchPage = '/search';
}

List<String> homeRouteList = [
  Routes.photosPage,
  Routes.albumsPage,
  Routes.explorePage,
  Routes.searchPage,
];
