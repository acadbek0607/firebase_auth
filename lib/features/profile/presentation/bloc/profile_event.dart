import 'package:equatable/equatable.dart';

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
  final dynamic profile;
  const SaveProfile(this.profile);
}

class ToggleSavedContractEvent extends ProfileEvent {
  final String contractId;
  const ToggleSavedContractEvent(this.contractId);
}

class CheckSavedStatus extends ProfileEvent {
  final String contractId;
  const CheckSavedStatus(this.contractId);
}
