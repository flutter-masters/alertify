import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/result.dart';
import '../core/typedefs.dart';
import '../entities/emergency_alert.dart';
import '../entities/friendship.dart';
import '../extensions/documents_snapshot_x.dart';
import '../failures/failure.dart';
import '../ui/shared/extensions/iterable_x.dart';

extension type FriendshipService(FirebaseFirestore db) {
  CollectionReference<Json> get _collection => db.collection('friendships');

  Future<List<Friendship>> _friendships(String userId) async {
    try {
      final snapshots = await _collection
          .where('status', isEqualTo: FriendshipStatus.active.name)
          .where('users', arrayContains: userId)
          .get();
      return snapshots.docs.map((e) => e.toFriendship()).toList();
    } catch (_) {
      rethrow;
    }
  }

  Stream<EmergencyAlert> onEmergencyAlert(String recipient) {
    final query = db
        .collection('alerts')
        .where('recipient', isEqualTo: recipient)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots();
    return query.expand<EmergencyAlert>(
      (event) => event.docs.map((doc) => doc.toEmergencyAlert()).toList(),
    );
  }

  FutureResult<List<FriendshipData>> getFriends(String userId) async {
    try {
      final friendships = await _friendships(userId);
      if (friendships.isEmpty) {
        return Success([]);
      }
      final friendshipIds = friendships
          .map((doc) => doc.users.firstWhereOrNull((id) => id != userId))
          .toList();
      final query = db
          .collection('users')
          .orderBy('email')
          .where('id', whereIn: friendshipIds);
      final snapshots = await query.get();
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
    } catch (_) {
      return Error(Failure(message: _.toString()));
    }
  }

  FutureResult<List<FriendshipData>> getFriendshipsRequest(
    String userId,
  ) async {
    try {
      final snapshot = await _collection
          .where('status', isEqualTo: FriendshipStatus.pending.name)
          .where('users', arrayContains: userId)
          .where('sender', isNotEqualTo: userId)
          .get();
      final friendships = snapshot.docs.map((e) => e.toFriendship()).toList();
      if (friendships.isEmpty) {
        return Success([]);
      }
      final friendshipsIds = friendships
          .map((friendship) => friendship.users.where((id) => id != userId))
          .toList();
      final userSnapshot = await db
          .collection('users')
          .where('id', arrayContains: friendshipsIds)
          .get();
      final users = userSnapshot.docs.map((doc) => doc.toAppUser()).toList();
      final data = <FriendshipData>[];
      for (final user in users) {
        final friendship = friendships.firstWhereOrNull(
          (friendship) => friendship.users.contains(user.id),
        );
        data.add((friendships: friendship, user: user));
      }
      return Success(data);
    } catch (_) {
      return Error(Failure(message: _.toString()));
    }
  }

  FutureResult<FriendshipData> searchUser(String userId, String email) async {
    try {
      final userSnapshot = await db
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      final userDocs = userSnapshot.docs;
      if (userDocs.isEmpty) {
        return Error(Failure(message: 'Usuario no existe'));
      }
      final user = userDocs.first.toAppUser();
      final friendshipSnapshot =
          await _collection.where('users', arrayContains: user.id).get();
      final friendships =
          friendshipSnapshot.docs.map((e) => e.toFriendship()).toList();
      Friendship? friendship;
      if (friendships.isNotEmpty) {
        friendship = friendships.firstWhereOrNull(
          (element) => element.users.contains(userId),
        );
      }
      return Success((friendships: friendship, user: user));
    } catch (_) {
      return Error(Failure(message: _.toString()));
    }
  }

  FutureResult<Friendship> sendFriendshipRequest({
    required String sender,
    required String recipientId,
  }) async {
    try {
      final snapshot = await _collection
          .where('users', arrayContains: recipientId)
          .where('sender', isEqualTo: sender)
          .where('status', isNotEqualTo: FriendshipStatus.archived.name)
          .limit(1)
          .get();
      final docs = snapshot.docs;
      final now = DateTime.now().toIso8601String();
      final data = <String, dynamic>{
        'users': [sender, recipientId],
        'sender': sender,
        'status': FriendshipStatus.pending.name,
        'createAt': now,
        'updateAt': now,
      };
      if (docs.isEmpty) {
        final ref = await _collection.add(data);
        return Success((await ref.get()).toFriendship());
      }
      final friendship = docs.first.toFriendship();
      if ([
        FriendshipStatus.active,
        FriendshipStatus.pending,
      ].contains(friendship.status)) {
        return Error(Failure(message: 'Solicitud ya existe'));
      }
      return Success(
        Friendship(
          id: friendship.id,
          status: friendship.status,
          createAt: friendship.createAt,
          updateAt: DateTime.timestamp(),
          sender: friendship.sender,
          users: friendship.users,
        ),
      );
    } catch (_) {
      return Error(Failure(message: _.toString()));
    }
  }

  FutureResult<void> acceptFriendshipRequest(
    String friendshipId,
  ) async {
    try {
      final ref = _collection.doc(friendshipId);
      final snapshot = await ref.get();
      if (!snapshot.exists) {
        return Error(Failure(message: 'Friendship no exists'));
      }
      await ref.set(
        {
          'status': FriendshipStatus.active.name,
          'updatedAt': DateTime.now().toIso8601String(),
        },
        SetOptions(merge: true),
      );
      return Success(null);
    } catch (e) {
      return Error(Failure(message: e.toString()));
    }
  }

  FutureResult<void> rejectFriendshipRequest(String friendshipId) async {
    try {
      final ref = _collection.doc(friendshipId);
      final snapshot = await ref.get();
      if (!snapshot.exists) {
        return Error(Failure(message: 'Friendship no exists'));
      }
      await ref.delete();
      return Success(null);
    } catch (e) {
      return Error(Failure(message: e.toString()));
    }
  }

  FutureResult<void> cancelFriendshipRequest(String friendshipId) async {
    try {
      final ref = _collection.doc(friendshipId);
      final snapshot = await ref.get();
      if (!snapshot.exists) {
        return Error(Failure(message: 'Friendship no exists'));
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
      return Error(Failure(message: e.toString()));
    }
  }

  FutureResult<void> sendAlert(String userId) async {
    try {
      final friendships = await _friendships(userId);
      final friendsIds = friendships
          .map((e) => e.users.firstWhere((id) => id != userId))
          .toList();
      if (friendsIds.isEmpty) {
        return Error(Failure(message: 'You do not have friends'));
      }
      final batch = db.batch();
      for (final recipient in friendsIds) {
        batch.set(
          _collection.doc(),
          {
            'senderId': userId,
            'recipient': recipient,
            'createdAt': DateTime.now().toIso8601String(),
          },
        );
      }
      await batch.commit();
      return Success(null);
    } catch (e) {
      return Error(Failure(message: e.toString()));
    }
  }
}
