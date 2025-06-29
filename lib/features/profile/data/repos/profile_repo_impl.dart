import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_auth/features/profile/data/models/profile_model.dart';
import 'package:fire_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:fire_auth/features/profile/domain/repos/profile_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRepoImpl implements ProfileRepo {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ProfileRepoImpl(this.firestore, this.auth);

  @override
  Future<void> createOrUpdateProfile(ProfileEntity profile) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');

    final model = ProfileModel.fromEntity(profile);
    await firestore.collection('profiles').doc(uid).set(model.toJson());
  }

  @override
  Future<ProfileEntity?> getProfile(String uid) async {
    final doc = await firestore.collection('profiles').doc(uid).get();
    if (doc.exists) {
      return ProfileModel.fromJson(doc.data()!).toEntity();
    }
    return null;
  }

  @override
  Future<void> toggleSavedContract(String uid, String contractId) async {
    final docRef = firestore.collection('profiles').doc(uid);
    final doc = await docRef.get();

    if (!doc.exists) return;

    final current = List<String>.from(doc.data()?['savedContractIds'] ?? []);
    if (current.contains(contractId)) {
      current.remove(contractId);
    } else {
      current.add(contractId);
    }

    await docRef.update({'savedContractIds': current});
  }

  @override
  Future<bool> isContractSaved(String uid, String contractId) async {
    final doc = await firestore.collection('profiles').doc(uid).get();
    if (!doc.exists) return false;

    final ids = List<String>.from(doc.data()?['savedContractIds'] ?? []);
    return ids.contains(contractId);
  }
}
