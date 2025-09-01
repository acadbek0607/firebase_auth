import 'package:equatable/equatable.dart';
import 'package:fire_auth/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String uid;
  const LoadProfile({required this.uid});
}

class SaveProfile extends ProfileEvent {
  final ProfileEntity profile;
  const SaveProfile(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ToggleSavedContractEvent extends ProfileEvent {
  final String contractId;
  const ToggleSavedContractEvent(this.contractId);
}

class CheckSavedStatus extends ProfileEvent {
  final String contractId;
  const CheckSavedStatus(this.contractId);
}
