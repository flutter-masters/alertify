import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/mobile_core_utils/failures/failure.dart';
import '../core/mobile_core_utils/result/result.dart';
import '../core/mobile_core_utils/typedefs/typedefs.dart';
import '../entities/app_user.dart';

extension type UserService(FirebaseFirestore db) {
  CollectionReference<Json> get _collection => db.collection('users');

  FutureResult<AppUser> createUser({
    required String id,
    required String username,
    required String email,
    String? photoUrl,
  }) async {
    try {
      await _collection.doc(id).set({
        'id': id,
        'email': email,
        'username': username,
        'photoUrl': photoUrl,
      });
      return Success(
        AppUser(
          id: id,
          email: email,
          username: username,
          photoUrl: photoUrl,
        ),
      );
    } catch (e) {
      return Err(Failure(message: e.toString()));
    }
  }
}
