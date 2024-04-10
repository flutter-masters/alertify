import 'package:firebase_auth/firebase_auth.dart';

import '../core/result.dart';
import '../core/typedefs.dart';
import '../entities/app_user.dart';
import '../failures/auth_failure.dart';

extension type AuthService(FirebaseAuth auth) {
  FutureAuthResult<void, SignInAuthFailure> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credentials = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credentials.user;
      if (user != null) {
        return Success(null);
      }
      return Error(SignInAuthFailure.userNotFound);
    } on FirebaseAuthException catch (e) {
      return Error(
        SignInAuthFailure.values.firstWhere(
          (failure) => failure.code == e.code,
          orElse: () => SignInAuthFailure.unknown,
        ),
      );
    } catch (_) {
      return Error(SignInAuthFailure.unknown);
    }
  }

  FutureAuthResult<AppUser, SignUpAuthFailure> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credentials = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credentials.user;
      if (user != null) {
        return Success(
          AppUser(
            id: user.uid,
            email: email,
            username: user.displayName ?? '',
            photoUrl: user.photoURL,
          ),
        );
      }
      return Error(SignUpAuthFailure.userNotCreate);
    } on FirebaseAuthException catch (e) {
      return Error(
        SignUpAuthFailure.values.firstWhere(
          (failure) => failure.code == e.code,
          orElse: () => SignUpAuthFailure.unknown,
        ),
      );
    } catch (e) {
      return Error(SignUpAuthFailure.unknown);
    }
  }

  bool get logged => auth.currentUser != null;

  Future<void> logout() => auth.signOut();

  String get currentUserId => auth.currentUser!.uid;
}
