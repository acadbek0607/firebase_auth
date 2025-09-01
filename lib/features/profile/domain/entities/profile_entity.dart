class ProfileEntity {
  final String uid; // <-- required for identifying the user
  final String email;
  final String? fullName;
  final String? dateOfBirth;
  final String? phone;
  final String? profession;
  final String? organization;
  final String? photoUrl;
  final List<String> savedContractIds;

  ProfileEntity({
    required this.uid,
    required this.email,
    this.fullName,
    this.dateOfBirth,
    this.phone,
    this.profession,
    this.organization,
    this.photoUrl,
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
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phone: phone ?? this.phone,
      profession: profession ?? this.profession,
      organization: organization ?? this.organization,
      photoUrl: photoUrl ?? this.photoUrl,
      savedContractIds: savedContractIds ?? this.savedContractIds,
    );
  }
}
