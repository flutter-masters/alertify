import '../../../../core/mobile_core_utils/typedefs/typedefs.dart';
import '../../../../entities/app_user.dart';

abstract interface class ProfileRepository {
  FutureResult<AppUser> userFromId(String id);

  Future<void> logout();
}
