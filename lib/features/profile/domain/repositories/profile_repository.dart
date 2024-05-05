import '../../../../core/typedefs.dart';
import '../../../../entities/app_user.dart';

abstract interface class ProfileRepository {
  FutureResult<AppUser> userFromId(String id);

  Future<void> logout();
}
