import 'package:fire_auth/core/constants/bloc_status.dart';
import 'package:fire_auth/features/profile/domain/usecase/profile_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile getProfile;
  final CreateOrUpdateProfile createOrUpdateProfile;
  final ToggleSavedContract toggleSavedContract;
  final IsContractSaved isContractSaved;
  final FirebaseAuth _auth;

  ProfileBloc({
    required this.getProfile,
    required this.createOrUpdateProfile,
    required this.toggleSavedContract,
    required this.isContractSaved,
    required FirebaseAuth firebaseAuth,
  }) : _auth = firebaseAuth,
       super(ProfileState.intial()) {
    on<LoadProfile>(_onLoadProfile);
    on<SaveProfile>(_onSaveProfile);
    on<ToggleSavedContractEvent>(_onToggleSavedContract);
    on<CheckSavedStatus>(_onCheckSavedStatus);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading, errorMessage: null));
    try {
      final profile = await getProfile(event.uid);
      if (profile != null) {
        emit(
          state.copyWith(
            status: BlocStatus.loaded,
            profile: profile,
            savedContractIds: profile.savedContractIds,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: BlocStatus.error,
            errorMessage: 'Profile not found.',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onSaveProfile(
    SaveProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await createOrUpdateProfile(event.profile);
      emit(
        state.copyWith(
          status: BlocStatus.loaded,
          profile: event.profile,
          savedContractIds: event.profile.savedContractIds,
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onToggleSavedContract(
    ToggleSavedContractEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      await toggleSavedContract(uid, event.contractId);
      final updatedProfile = await getProfile(uid);
      if (updatedProfile != null) {
        emit(
          state.copyWith(
            status: BlocStatus.loaded,
            profile: updatedProfile,
            savedContractIds: updatedProfile.savedContractIds,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onCheckSavedStatus(
    CheckSavedStatus event,
    Emitter<ProfileState> emit,
  ) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      final profile = await getProfile(uid);
      if (profile != null) {
        emit(
          state.copyWith(
            status: BlocStatus.loaded,
            profile: profile,
            savedContractIds: profile.savedContractIds,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
