class ProfileEntity {
  final String uid; // <-- required for identifying the user
  final String email;
  final List<String> savedContractIds;

  ProfileEntity({
    required this.uid,
    required this.email,
    this.savedContractIds = const [],
  });

  ProfileEntity copyWith({
    String? uid,
    String? fullName,
    String? dateOfBirth,
    String? phone,
    String? profession,
    String? organization,
    String? email,
    String? photoUrl,
    List<String>? savedContractIds,
  }) {
    return ProfileEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      savedContractIds: savedContractIds ?? this.savedContractIds,
    );
  }
}
