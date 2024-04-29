import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../../../core/result.dart';
import '../../../../core/typedefs.dart';

class FriendshipController
    extends AutoDisposeAsyncNotifier<List<FriendshipData>> {
  @override
  FutureOr<List<FriendshipData>> build() async {
    final currentUserId = ref.watch(userServiceProvider).currentUserId;
    final result = await ref.watch(friendshipServiceProvider).getFriends(
          currentUserId,
        );

    return switch (result) {
      Success(value: final friendship) => friendship,
      Err(value: final failure) => throw Exception(failure.message),
    };
  }

  Future<void> delete(FriendshipData friendshipData) async {
    final currentFriendships = state.requireValue;
    state = await AsyncValue.guard(() async {
      final repository = ref.read(friendshipServiceProvider);
      final result = await repository.cancelFriendshipRequest(
        friendshipData.friendships!.id,
      );

      return switch (result) {
        Success() => currentFriendships..remove(friendshipData),
        Err() => currentFriendships,
      };
    });
  }
}

final friendshipControllerProvider = AsyncNotifierProvider.autoDispose<
    FriendshipController, List<FriendshipData>>(FriendshipController.new);
