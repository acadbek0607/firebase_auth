import 'package:fire_auth/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.uid,
    required super.email,
    super.fullName,
    super.dateOfBirth,
    super.phone,
    super.profession,
    super.organization,
    super.photoUrl,
    required super.savedContractIds,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      email: json['email'] ?? '',
      savedContractIds: List<String>.from(json['savedContractIds'] ?? []),
      uid: json["uid"] ?? '',
      fullName: json['fullName'],
      dateOfBirth: json['dateOfBirth'],
      phone: json['phone'],
      profession: json['profession'],
      organization: json['organization'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
      'phone': phone,
      'profession': profession,
      'organization': organization,
      'photoUrl': photoUrl,
      'savedContractIds': savedContractIds,
    };
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      email: entity.email,
      savedContractIds: entity.savedContractIds,
      uid: entity.uid,
      fullName: entity.fullName,
      dateOfBirth: entity.dateOfBirth,
      phone: entity.phone,
      profession: entity.profession,
      organization: entity.organization,
      photoUrl: entity.photoUrl,
    );
  }

  ProfileEntity toEntity() => this;
}
