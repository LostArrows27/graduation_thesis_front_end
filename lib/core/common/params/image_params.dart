class ImageParams {
  final String imageId;
  final String imageBucketId;
  final String imageName;

  ImageParams(
      {required this.imageBucketId,
      required this.imageName,
      required this.imageId});
}

List<ImageParams> fakeImageParams = [
  ImageParams(
      imageId: "1",
      imageBucketId: 'gallery_image',
      imageName: '465703811_992450546249092_9009903849096757431_n.jpg'),
  ImageParams(
      imageId: "2",
      imageBucketId: 'gallery_image',
      imageName: '466738572_992450549582425_8785332279904258979_n.jpg'),
  ImageParams(
      imageId: "3",
      imageBucketId: 'gallery_image',
      imageName: '476930847_925116493113986_6115386592352309686_n.jpg'),
];
