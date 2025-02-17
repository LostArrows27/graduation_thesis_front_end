class ImageParams {
  final String imageBucketId;
  final String imageName;

  ImageParams({required this.imageBucketId, required this.imageName});
}

List<ImageParams> fakeImageParams = [
  ImageParams(
      imageBucketId: 'gallery_image',
      imageName: '465703811_992450546249092_9009903849096757431_n.jpg'),
  ImageParams(
      imageBucketId: 'gallery_image',
      imageName: '466738572_992450549582425_8785332279904258979_n.jpg'),
  ImageParams(
      imageBucketId: 'gallery_image',
      imageName: '476930847_925116493113986_6115386592352309686_n.jpg'),
];
