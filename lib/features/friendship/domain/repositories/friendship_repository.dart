import '../../../../core/typedefs.dart';

abstract interface class FriendshipRepository {
  FutureResult<List<FriendshipData>> getFriends(String userId);

  FutureResult<void> cancelFriendshipRequest(String friendshipId);
}
