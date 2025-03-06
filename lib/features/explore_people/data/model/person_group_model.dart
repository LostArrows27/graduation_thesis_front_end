import 'package:graduation_thesis_front_end/features/explore_people/data/model/face_model.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/face.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/person_group.dart';

class PersonGroupModel extends PersonGroup {
  PersonGroupModel(
      {required super.clusterId, required super.name, required super.faces});

  factory PersonGroupModel.fromJson(Map<String, dynamic> map) {
    return PersonGroupModel(
      clusterId: map['cluster_id'] as int,
      name: map['cluster_name'] as String,
      faces: List<Face>.from(
        (map['person'] as List<dynamic>).map<Face>(
          (x) => FaceModel.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}
