import 'package:graduation_thesis_front_end/core/common/entities/user.dart';

class UserModel extends User {
  UserModel(
      {required super.id,
      required super.name,
      required super.email,
      super.dob,
      super.avatarUrl,
      super.surveyAnswers});

  factory UserModel.fromJSON(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      dob: map['dob'] == null ? null : DateTime.parse(map['dob']),
      avatarUrl: map['avatar_url'],
      surveyAnswers: map['survey_answers'],
    );
  }

  factory UserModel.fromUser(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      dob: user.dob,
      avatarUrl: user.avatarUrl,
      surveyAnswers: user.surveyAnswers,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? dob,
    String? avatarUrl,
    List<String>? surveyAnswers,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      surveyAnswers: surveyAnswers ?? this.surveyAnswers,
    );
  }
}
