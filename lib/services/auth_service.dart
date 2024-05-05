import 'package:firebase_auth/firebase_auth.dart';

import '../core/mobile_core_utils/failures/auth_failure.dart';
import '../core/mobile_core_utils/result/result.dart';
import '../core/mobile_core_utils/typedefs/typedefs.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repo.dart';

class FirebaseAuthAdapter implements AuthRepo {
  const FirebaseAuthAdapter(this.client);
  final FirebaseAuth client;

  FutureAuthResult<AppUser, SignUpAuthFailure> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credentials = await client.createUserWithEmailAndPassword(
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
      return Err(SignUpAuthFailure.userNotCreate);
    } on FirebaseAuthException catch (e) {
      return Err(
        SignUpAuthFailure.values.firstWhere(
          (failure) => failure.code == e.code,
          orElse: () => SignUpAuthFailure.unknown,
        ),
      );
    } catch (e) {
      return Err(SignUpAuthFailure.unknown);
    }
  }

  bool get logged => client.currentUser != null;
}

// extension type AuthService(FirebaseAuth auth) {
//   FutureAuthResult<void, SignInAuthFailure> signIn({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final credentials = await auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       final user = credentials.user;
//       if (user != null) {
//         return Success(null);
//       }
//       return Err(SignInAuthFailure.userNotFound);
//     } on FirebaseAuthException catch (e) {
//       return Err(
//         SignInAuthFailure.values.firstWhere(
//           (failure) => failure.code == e.code,
//           orElse: () => SignInAuthFailure.unknown,
//         ),
//       );
//     } catch (_) {
//       return Err(SignInAuthFailure.unknown);
//     }
//   }

//   FutureAuthResult<AppUser, SignUpAuthFailure> signUp({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final credentials = await auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       final user = credentials.user;
//       if (user != null) {
//         return Success(
//           AppUser(
//             id: user.uid,
//             email: email,
//             username: user.displayName ?? '',
//             photoUrl: user.photoURL,
//           ),
//         );
//       }
//       return Err(SignUpAuthFailure.userNotCreate);
//     } on FirebaseAuthException catch (e) {
//       return Err(
//         SignUpAuthFailure.values.firstWhere(
//           (failure) => failure.code == e.code,
//           orElse: () => SignUpAuthFailure.unknown,
//         ),
//       );
//     } catch (e) {
//       return Err(SignUpAuthFailure.unknown);
//     }
//   }

//   Future<void> logout() => auth.signOut();

//   bool get logged => auth.currentUser != null;
//   String get currentUserId => auth.currentUser!.uid;
// }
