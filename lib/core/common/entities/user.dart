// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String id;
  final String name;
  final String email;
  final DateTime? dob;
  final String? avatarUrl;
  final DateTime? createdAt;
  final List<String>? surveyAnswers;
  final bool isDoneLabelForm;
  User(
      {required this.id,
      required this.name,
      required this.email,
      this.createdAt,
      this.dob,
      this.avatarUrl,
      this.surveyAnswers,
      this.isDoneLabelForm = false});
}
