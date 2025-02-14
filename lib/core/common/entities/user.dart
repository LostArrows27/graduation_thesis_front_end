// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String id;
  final String name;
  final String email;
  final DateTime? dob;
  final String? avatarUrl;
  User({
    required this.id,
    required this.name,
    required this.email,
    this.dob,
    this.avatarUrl,
  });
}
