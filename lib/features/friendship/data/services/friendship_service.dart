import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/mobile_core_utils/extensions/documents_snapshot_x.dart';
import '../../../../core/mobile_core_utils/failures/failure.dart';
import '../../../../core/mobile_core_utils/result/result.dart';
import '../../../../core/mobile_core_utils/typedefs/typedefs.dart';
import '../../../../entities/friendship.dart';
import '../../../../ui/shared/extensions/iterable_x.dart';
import '../../domain/repositories/friendship_repository.dart';

class FriendshipService implements FriendshipRepository {
  FriendshipService(this.db);

  final FirebaseFirestore db;

  CollectionReference<Json> get _friendshipCollection =>
      db.collection('friendships');

  CollectionReference<Json> get _userCollection => db.collection('users');

  @override
  FutureResult<List<FriendshipData>> getFriends(String userId) async {
    try {
      final friendships = await _friendships(userId);
      if (friendships.isEmpty) return Success([]);

      final friendshipIds = friendships
          .map((doc) => doc.users.firstWhereOrNull((id) => id != userId))
          .toList();

      final snapshots = await _userCollection
          .orderBy('email')
          .where('id', whereIn: friendshipIds)
          .get();

      final users = snapshots.docs
          .where((element) => element.exists)
          .map((e) => e.toAppUser())
          .toList();

      final data = <FriendshipData>[];
      for (final user in users) {
        final friendship = friendships.firstWhereOrNull(
          (friendship) => friendship.users.contains(user.id),
        );
        data.add((friendships: friendship, user: user));
      }
      return Success(data);
    } catch (e) {
      return Err(Failure(message: e.toString()));
    }
  }

  @override
  FutureResult<void> cancelFriendshipRequest(String friendshipId) async {
    try {
      final ref = _friendshipCollection.doc(friendshipId);
      final snapshot = await ref.get();
      if (!snapshot.exists) {
        return Err(Failure(message: 'Friendship no exists'));
      }
      await ref.set(
        {
          'status': FriendshipStatus.archived.name,
          'updatedAt': DateTime.now().toIso8601String(),
        },
        SetOptions(merge: true),
      );
      return Success(null);
    } catch (e) {
      return Err(Failure(message: e.toString()));
    }
  }

  Future<List<Friendship>> _friendships(String userId) async {
    try {
      final snapshots = await _friendshipCollection
          .where('status', isEqualTo: FriendshipStatus.active.name)
          .where('users', arrayContains: userId)
          .get();
      return snapshots.docs.map((e) => e.toFriendship()).toList();
    } catch (_) {
      rethrow;
    }
  }
}
