import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/mobile_core_utils/extensions/documents_snapshot_x.dart';
import '../../../../core/mobile_core_utils/failures/failure.dart';
import '../../../../core/mobile_core_utils/result/result.dart';
import '../../../../core/mobile_core_utils/typedefs/typedefs.dart';
import '../../../../entities/app_user.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileService implements ProfileRepository {
  ProfileService(this.auth, this.db);

  final FirebaseAuth auth;
  final FirebaseFirestore db;

  CollectionReference<Json> get _collection => db.collection('users');

  @override
  FutureResult<AppUser> userFromId(String id) async {
    try {
      final snapshot = await _collection.doc(id).get();
      if (!snapshot.exists) {
        return Err(Failure(message: 'User no found'));
      }
      return Success(snapshot.toAppUser());
    } catch (e) {
      return Err(Failure(message: e.toString()));
    }
  }

  @override
  Future<void> logout() => auth.signOut();
}
