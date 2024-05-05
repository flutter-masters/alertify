import '../core/mobile_core_utils/failures/auth_failure.dart';
import '../core/mobile_core_utils/typedefs/typedefs.dart';
import '../entities/app_user.dart';

abstract interface class AuthRepo {
  FutureAuthResult<AppUser, SignUpAuthFailure> signUp({
    required String email,
    required String password,
  });

  // TODO: Remover estos getters
  bool get logged;
}
