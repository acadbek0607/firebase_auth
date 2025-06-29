import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String uid;
  const LoadProfile({required this.uid});

  @override
  List<Object?> get props => [uid];
}

class SaveProfile extends ProfileEvent {
  final dynamic profile;
  const SaveProfile(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ToggleSavedContractEvent extends ProfileEvent {
  final String contractId;
  const ToggleSavedContractEvent(this.contractId);

  @override
  List<Object?> get props => [contractId];
}

class CheckSavedStatus extends ProfileEvent {
  final String contractId;
  const CheckSavedStatus(this.contractId);

  @override
  List<Object?> get props => [contractId];
}
