import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../services/friendship_service.dart';
import '../../../core/mobile_core_utils/failures/failure.dart';
import '../../../core/mobile_core_utils/result/result.dart';
import '../../../core/mobile_core_utils/typedefs/typedefs.dart';
import '../../../core/providers.dart';
import '../../../entities/friendship.dart';
import '../../shared/dialogs/loader_dialog.dart';
import '../../shared/validators/form_validator.dart';
import '../../shared/widgets/user_list.dart';
import '../../shared/widgets/user_tile.dart';
import '../home/tabs/requests/widgets/request_tile.dart';
import 'widgets/app_bar.dart';

sealed class SearchState {}

class SearchLoadingState extends SearchState {}

class SearchLoadedState extends SearchState {
  SearchLoadedState({required this.data});
  final List<FriendshipData> data;
}

class SearchLoadErrorState extends SearchState {
  SearchLoadErrorState({required this.error});
  final String error;
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  static const String route = '/search';

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  SearchState state = SearchLoadingState();
  final friendshipsService = FriendshipService(FirebaseFirestore.instance);
  String get userId => ref.read(userServiceProvider).currentUserId;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadFriendshipsRequest(),
    );
    super.initState();
  }

  Future<void> loadFriendshipsRequest() async {
    state = SearchLoadingState();
    setState(() {});
    final result = await friendshipsService.getFriendshipsRequest(userId);
    state = switch (result) {
      Success(value: final requests) => SearchLoadedState(data: requests),
      Err(value: final failure) => SearchLoadErrorState(
          error: failure.message,
        ),
    };
    setState(() {});
  }

  Future<void> searchUser(String email) async {
    state = SearchLoadingState();
    setState(() {});
    final result = await friendshipsService.searchUser(userId, email);
    state = switch (result) {
      Success(value: final friendshipData) => SearchLoadedState(
          data: [friendshipData],
        ),
      Err(value: final failure) => SearchLoadErrorState(
          error: failure.message,
        ),
    };
    setState(() {});
  }

  Future<void> sentFrienship(FriendshipData friendshipData) async {
    final result = await showLoader(
      context,
      friendshipsService.sendFriendshipRequest(
        sender: userId,
        recipientId: friendshipData.user.id,
      ),
    );
    final friendshipsData = switch (result) {
      Success(value: final friendship) => addNewData(
          friendship,
          friendshipData,
        ),
      Err() => data,
    };
    state = SearchLoadedState(data: friendshipsData);
    setState(() {});
  }

  Future<void> cancelFriendship(FriendshipData friendshipData) async {
    final friendship = friendshipData.friendships!;
    final result = await showLoader(
      context,
      friendshipsService.cancelFriendshipRequest(friendship.id),
    );
    final friendshipsData = switch (result) {
      Success() => addNewData(
          Friendship(
            id: friendship.id,
            status: FriendshipStatus.archived,
            createAt: friendship.createAt,
            updateAt: DateTime.now(),
            sender: friendship.sender,
            users: friendship.users,
          ),
          friendshipData,
        ),
      Err() => data,
    };
    state = SearchLoadedState(data: friendshipsData);
    setState(() {});
  }

  Future<void> acceptFriendshipRequest(FriendshipData friendshipData) async {
    final result = await showLoader(
      context,
      friendshipsService
          .acceptFriendshipRequest(friendshipData.friendships!.id),
    );
    friendshipActionResultToState(result, friendshipData);
  }

  Future<void> rejectFriendshipRequest(FriendshipData friendshipData) async {
    final result = await showLoader(
      context,
      friendshipsService
          .rejectFriendshipRequest(friendshipData.friendships!.id),
    );
    friendshipActionResultToState(result, friendshipData);
  }

  void friendshipActionResultToState(
    Result<void, Failure> result,
    FriendshipData friendshipData,
  ) {
    final friendshipsData = switch (result) {
      Success() => [...data]..remove(friendshipData),
      Err() => data,
    };
    state = SearchLoadedState(data: friendshipsData);
    setState(() {});
  }

  List<FriendshipData> addNewData(
    Friendship friendship,
    FriendshipData friendshipData,
  ) {
    final friendshipsData = [...data];
    final index = friendshipsData.indexWhere(
      (f) => f.user.id == friendshipData.user.id,
    );
    if (index != -1) {
      friendshipsData[index] = (
        user: friendshipsData[index].user,
        friendships: friendship,
      );
    }
    return friendshipsData;
  }

  List<FriendshipData> get data => switch (state) {
        SearchLoadedState(data: final data) => data,
        _ => [],
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        onSearch: (email) {
          if (email.isEmpty) {
            loadFriendshipsRequest();
          }
          if (FormValidator.email(email) == null) {
            searchUser(email);
          }
        },
      ),
      body: switch (state) {
        SearchLoadingState() => const Center(
            child: CircularProgressIndicator(),
          ),
        SearchLoadedState(data: final data) when data.isEmpty => const Center(
            child: Text('No hay datos...'),
          ),
        SearchLoadedState(data: final data) => UserList(
            data: data,
            builder: (_, friendshipData) {
              final user = friendshipData.user;
              final friendship = friendshipData.friendships;
              final status = friendship?.status;
              return switch (status) {
                null || FriendshipStatus.archived => UserTile(
                    onPressed: () => sentFrienship(friendshipData),
                    username: user.username,
                    email: user.email,
                    trailingIcon: Icons.person_add_alt_1_rounded,
                  ),
                FriendshipStatus.pending when friendship?.sender == userId =>
                  UserTile(
                    onPressed: () => cancelFriendship(friendshipData),
                    username: user.username,
                    email: user.email,
                    trailingIcon: Icons.person_remove_alt_1_rounded,
                  ),
                FriendshipStatus.pending => RequestTile(
                    onAccept: () => acceptFriendshipRequest(friendshipData),
                    onReject: () => rejectFriendshipRequest(friendshipData),
                    username: user.username,
                    email: user.email,
                    photoUrl: user.photoUrl,
                  ),
                FriendshipStatus.active => UserTile(
                    onPressed: () => cancelFriendship(friendshipData),
                    username: friendshipData.user.username,
                    email: friendshipData.user.email,
                  ),
              };
            },
          ),
        SearchLoadErrorState(error: final error) => Center(child: Text(error)),
      },
    );
  }
}
