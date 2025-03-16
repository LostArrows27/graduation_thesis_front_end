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

  static const String videoRenderStatusPage = '/video-render-status';
  static const String videoImagePickerPage = '/video-image-picker';
  static const String editVideoSchemaPage = '/edit-video-schema';
  static const String videoRenderResult = '/video-render-result';
  static const String videoViewerPage = '/video-viewer';

  static const String peopleExplorePage = '/people-explore';
  static const String peopleDetailPage = '/people-detail';

  static const String uploadPhotoPage = '/upload-photo';
  static const String imageSliderPage = '/image-slider';
  // NOTE: also use both month view
  static const String albumViewerPage = '/album-viewer';
  static const String yearAlbumViewerPage = '/year-album-viewer';

  static const String smartTagsViewerPage = '/smart-tag-viewer-page';

  static const String fullySearchPage = '/fully-search-page';

  static const String pickImageLocationPage = '/pick-image-location-page';

  static const String exploreLocationPage = '/explore-location-page';
  static const String imageLocationGroupMapPage =
      '/image-location-group-map-page';

  // test route
  static const String photoViewDemo = '/photo-view-demo';
  static const String photoSliderDemo = '/photo-slider-demo';
  static const String testSearchPage = '/test-search-page';
  static const String testGoogleMapPage = '/test-google-map-page';
}

List<String> homeRouteList = [
  Routes.photosPage,
  Routes.albumsPage,
  Routes.explorePage,
  Routes.searchPage,

  Routes.videoRenderStatusPage,
  Routes.videoImagePickerPage,
  Routes.editVideoSchemaPage,
  Routes.videoRenderResult,
  Routes.videoViewerPage,

  Routes.peopleExplorePage,
  Routes.peopleDetailPage,

  Routes.uploadPhotoPage,
  Routes.imageSliderPage,
  Routes.albumViewerPage,
  Routes.yearAlbumViewerPage,

  Routes.smartTagsViewerPage,

  Routes.fullySearchPage,

  Routes.pickImageLocationPage,

  Routes.exploreLocationPage,
  Routes.imageLocationGroupMapPage,

  // test route
  Routes.photoViewDemo,
  Routes.photoSliderDemo,
  Routes.testGoogleMapPage,
];
