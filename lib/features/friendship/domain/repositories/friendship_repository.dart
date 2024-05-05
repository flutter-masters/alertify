import '../../../../core/mobile_core_utils/typedefs/typedefs.dart';

abstract interface class FriendshipRepository {
  FutureResult<List<FriendshipData>> getFriends(String userId);

  FutureResult<void> cancelFriendshipRequest(String friendshipId);
}
