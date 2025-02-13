// core not depened on features
// features depend on core
class User {
  final String id;
  final String name;
  final String email;
  final String dob;
  final String? avatarUrl;

  User(this.dob, this.avatarUrl,
      {required this.id, required this.name, required this.email});
}
