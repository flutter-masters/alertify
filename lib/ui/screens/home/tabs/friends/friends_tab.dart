import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../core/result.dart';
import '../../../../../core/typedefs.dart';
import '../../../../../services/auth_service.dart';
import '../../../../../services/friendship_service.dart';
import '../../../../shared/dialogs/loader_dialog.dart';
import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/widgets/user_list.dart';
import '../../../../shared/widgets/user_tile.dart';
import '../../../search/search_screen.dart';
import 'widgets/app_bar.dart';

sealed class FriendState {
  const FriendState();
}

class FriendLoadingState extends FriendState {}

class FriendLoadedState extends FriendState {
  const FriendLoadedState({required this.friends});
  final List<FriendshipData> friends;
}

class FriendLoadErrorState extends FriendState {
  FriendLoadErrorState({required this.error});
  final String error;
}

class FriendsTab extends StatefulWidget {
  const FriendsTab({super.key});

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  FriendState state = FriendLoadingState();
  final friendshipsService = FriendshipService(FirebaseFirestore.instance);
  final userId = AuthService(FirebaseAuth.instance).currentUserId;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => loadFriends());
    super.initState();
  }

  Future<void> loadFriends() async {
    state = FriendLoadingState();
    setState(() {});
    final result = await friendshipsService.getFriends(userId);
    state = switch (result) {
      Success(value: final friends) => FriendLoadedState(friends: friends),
      Error(value: final failure) => FriendLoadErrorState(
          error: failure.message,
        ),
    };
    setState(() {});
  }

  Future<void> onDelete(FriendshipData friendshipData) async {
    final deleted = await showLoader(
      context,
      friendshipsService.cancelFriendshipRequest(
        friendshipData.friendships!.id,
      ),
    );
    final friendsData = switch (deleted) {
      Success() => [...data]..remove(friendshipData),
      Error() => data,
    };
    state = FriendLoadedState(friends: friendsData);
    setState(() {});
  }

  List<FriendshipData> get data => switch (state) {
        FriendLoadedState(friends: final friendsData) => friendsData,
        _ => [],
      };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          FriendsAppbar(onAdd: () => context.pushNamed(SearchScreen.route)),
          Expanded(
            child: switch (state) {
              FriendLoadingState() => const Center(
                  child: CircularProgressIndicator(),
                ),
              FriendLoadedState(friends: final friends) when friends.isEmpty =>
                const Center(
                  child: Text(
                    'No tienes amigos...',
                  ),
                ),
              FriendLoadedState(friends: final friends) => UserList(
                  data: friends,
                  builder: (_, friendshipData) => UserTile(
                    onPressed: () => onDelete(friendshipData),
                    username: friendshipData.user.username,
                    email: friendshipData.user.email,
                  ),
                ),
              FriendLoadErrorState(error: final error) => Center(
                  child: Text(error),
                ),
            },
          ),
        ],
      ),
    );
  }
}
