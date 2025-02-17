import 'package:graduation_thesis_front_end/core/common/entities/label.dart';

class Image {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? uploaderId;
  final String imageBucketId;
  final String imageName;
  final LabelResponse labels;

  Image(
      {required this.id,
      this.createdAt,
      this.updatedAt,
      required this.uploaderId,
      required this.imageBucketId,
      required this.imageName,
      required this.labels});
}

LabelResponse labelResponseFake = LabelResponse(
    labels: Labels(locationLabels: [
  Label(label: "bridge", confidence: 0.92),
  Label(label: "forest", confidence: 0.03),
], actionLabels: [
  Label(label: "taking nature photo", confidence: 0.92),
  Label(label: "taking landscape photo", confidence: 0.03),
], eventLabels: [
  Label(label: "morning", confidence: 0.92),
  Label(label: "travelling", confidence: 0.03),
]));

List<Image> imageListFake = [
  Image(
      id: '1',
      uploaderId: 'abc',
      imageBucketId: 'gallery_image',
      imageName: 'test',
      labels: labelResponseFake),
  Image(
      id: '2',
      uploaderId: 'abc',
      imageBucketId: 'gallery_image',
      imageName: 'test',
      labels: labelResponseFake),
  Image(
      id: '3',
      uploaderId: 'abc',
      imageBucketId: 'gallery_image',
      imageName: 'test',
      labels: labelResponseFake),
];
