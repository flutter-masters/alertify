import '../../../../core/mobile_core_utils/failures/auth_failure.dart';
import '../../../../core/mobile_core_utils/typedefs/typedefs.dart';

abstract interface class SignInRepository {
  FutureAuthResult<void, SignInAuthFailure> signIn({
    required String email,
    required String password,
  });
}
