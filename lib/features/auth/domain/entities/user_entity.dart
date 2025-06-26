class UserEntity {
  final String uid;
  final String? email;
  final String? username;
  final String? photoUrl;

  UserEntity({
    required this.uid,
    required this.email,
    this.username,
    this.photoUrl,
  });
}
