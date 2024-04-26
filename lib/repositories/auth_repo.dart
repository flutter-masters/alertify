import '../core/typedefs.dart';
import '../entities/app_user.dart';
import '../failures/auth_failure.dart';

abstract interface class AuthRepo {
  FutureAuthResult<void, SignInAuthFailure> signIn({
    required String email,
    required String password,
  });

  FutureAuthResult<AppUser, SignUpAuthFailure> signUp({
    required String email,
    required String password,
  });

  Future<void> logout();

  // TODO: Remover estos getters
  bool get logged;
  String get currentUserId;
}
