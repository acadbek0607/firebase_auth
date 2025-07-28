import 'package:fire_auth/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.uid,
    required super.email,
    required super.savedContractIds,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      email: json['email'] ?? '',
      savedContractIds: List<String>.from(json['savedContractIds'] ?? []),
      uid: json["uid"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'savedContractIds': savedContractIds, 'uid': uid};
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      email: entity.email,
      savedContractIds: entity.savedContractIds,
      uid: entity.uid,
    );
  }

  ProfileEntity toEntity() => this;
}
