import 'package:equatable/equatable.dart';
import 'package:fire_auth/core/constants/bloc_status.dart';
import 'package:fire_auth/features/profile/domain/entities/profile_entity.dart';

class ProfileState extends Equatable {
  final BlocStatus status;
  final ProfileEntity? profile;
  final List<String> savedContractIds;
  final String? errorMessage;
  final bool? isSaved;

  const ProfileState({
    this.status = BlocStatus.initial,
    this.profile,
    this.savedContractIds = const [],
    this.errorMessage,
    this.isSaved,
  });

  factory ProfileState.intial() => const ProfileState();

  ProfileState copyWith({
    BlocStatus? status,
    ProfileEntity? profile,
    List<String>? savedContractIds,
    String? errorMessage,
    bool? isSaved,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      savedContractIds: savedContractIds ?? this.savedContractIds,
      errorMessage: errorMessage,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object?> get props => [
    status,
    profile,
    savedContractIds,
    errorMessage,
    isSaved,
  ];
}
