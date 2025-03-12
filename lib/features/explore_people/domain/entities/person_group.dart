import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/face.dart';

class PersonGroup {
  final int clusterId;
  final String name;
  final List<Face> faces;

  PersonGroup(
      {required this.clusterId, required this.name, required this.faces});

  PersonGroup copyWith({
    int? clusterId,
    String? name,
    List<Face>? faces,
  }) {
    return PersonGroup(
      clusterId: clusterId ?? this.clusterId,
      name: name ?? this.name,
      faces: faces ?? this.faces,
    );
  }
}
