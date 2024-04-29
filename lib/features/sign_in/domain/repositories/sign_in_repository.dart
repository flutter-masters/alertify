import '../../../../core/typedefs.dart';
import '../../../../failures/auth_failure.dart';

abstract interface class SignInRepository {
  FutureAuthResult<void, SignInAuthFailure> signIn({
    required String email,
    required String password,
  });
}
