import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/mobile_core_utils/failures/auth_failure.dart';
import '../../../../core/mobile_core_utils/result/result.dart';
import '../../../../core/mobile_core_utils/typedefs/typedefs.dart';
import '../../domain/repositories/sign_in_repository.dart';

class SignInService implements SignInRepository {
  const SignInService(this.client);

  final FirebaseAuth client;

  @override
  FutureAuthResult<void, SignInAuthFailure> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credentials = await client.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credentials.user;
      if (user != null) {
        return Success(null);
      }
      return Err(SignInAuthFailure.userNotFound);
    } on FirebaseAuthException catch (e) {
      return Err(
        SignInAuthFailure.values.firstWhere(
          (failure) => failure.code == e.code,
          orElse: () => SignInAuthFailure.unknown,
        ),
      );
    } catch (_) {
      return Err(SignInAuthFailure.unknown);
    }
  }
}
