class ProfileEntity {
  final String uid; // <-- required for identifying the user
  final String fullName;
  final String phone;
  final String profession;
  final String organization;
  final String email;
  final String? photoUrl;
  final List<String> savedContractIds;

  ProfileEntity({
    required this.uid,
    required this.fullName,
    required this.phone,
    required this.profession,
    required this.organization,
    required this.email,
    this.photoUrl,
    this.savedContractIds = const [],
  });

  ProfileEntity copyWith({
    String? uid,
    String? fullName,
    String? phone,
    String? profession,
    String? organization,
    String? email,
    String? photoUrl,
    List<String>? savedContractIds,
  }) {
    return ProfileEntity(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      profession: profession ?? this.profession,
      organization: organization ?? this.organization,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      savedContractIds: savedContractIds ?? this.savedContractIds,
    );
  }
}
