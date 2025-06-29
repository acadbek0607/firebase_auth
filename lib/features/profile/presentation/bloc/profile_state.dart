import 'package:equatable/equatable.dart';
import 'package:fire_auth/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;
  final List<String> savedContractIds;

  const ProfileLoaded({required this.profile, required this.savedContractIds});

  @override
  List<Object?> get props => [profile, savedContractIds];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class ContractSavedStatus extends ProfileState {
  final bool isSaved;

  const ContractSavedStatus(this.isSaved);

  @override
  List<Object?> get props => [isSaved];
}
