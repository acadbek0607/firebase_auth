import 'package:fire_auth/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.fullName,
    required super.phone,
    required super.profession,
    required super.organization,
    required super.email,
    super.photoUrl,
    required super.savedContractIds,
    required super.uid,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      profession: json['profession'] ?? '',
      organization: json['organization'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'],
      savedContractIds: List<String>.from(json['savedContractIds'] ?? []),
      uid: json["uid"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phone': phone,
      'profession': profession,
      'organization': organization,
      'email': email,
      'photoUrl': photoUrl,
      'savedContractIds': savedContractIds,
      'uid': uid,
    };
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      fullName: entity.fullName,
      phone: entity.phone,
      profession: entity.profession,
      organization: entity.organization,
      email: entity.email,
      photoUrl: entity.photoUrl,
      savedContractIds: entity.savedContractIds,
      uid: entity.uid,
    );
  }

  ProfileEntity toEntity() => this;
}
