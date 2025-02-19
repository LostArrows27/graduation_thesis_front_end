import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/common/entities/label.dart';

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

List<Photo> imageListFake = [
  Photo(
      id: '1',
      uploaderId: 'abc',
      imageBucketId: 'gallery_image',
      imageName: 'test',
      labels: labelResponseFake),
  Photo(
      id: '2',
      uploaderId: 'abc',
      imageBucketId: 'gallery_image',
      imageName: 'test',
      labels: labelResponseFake),
  Photo(
      id: '3',
      uploaderId: 'abc',
      imageBucketId: 'gallery_image',
      imageName: 'test',
      labels: labelResponseFake),
];
