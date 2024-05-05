import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/result.dart';
import '../core/typedefs.dart';
import '../entities/app_user.dart';
import '../failures/failure.dart';

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
