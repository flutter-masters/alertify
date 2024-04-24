import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../core/result.dart';
import '../../../../../core/typedefs.dart';
import '../../../../../failures/failure.dart';
import '../../../../../services/auth_service.dart';
import '../../../../../services/friendship_service.dart';
import '../../../../shared/dialogs/loader_dialog.dart';
import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/widgets/user_list.dart';
import 'widgets/app_bar.dart';
import 'widgets/request_tile.dart';

sealed class RequestState {}

class RequestLoadingState extends RequestState {}

class RequestLoadedState extends RequestState {
  RequestLoadedState({required this.requests});
  final List<FriendshipData> requests;
}

class RequestLoadErrorState extends RequestState {
  RequestLoadErrorState({required this.error});
  final String error;
}

class RequestsTab extends StatefulWidget {
  const RequestsTab({super.key});

  @override
  State<RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  RequestState state = RequestLoadingState();
  final friendshipsService = FriendshipService(FirebaseFirestore.instance);
  final userId = AuthService(FirebaseAuth.instance).currentUserId;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => loadRequest());
    super.initState();
  }

  Future<void> loadRequest() async {
    state = RequestLoadingState();
    setState(() {});
    final result = await friendshipsService.getFriendshipsRequest(userId);
    state = switch (result) {
      Success(value: final requests) => RequestLoadedState(requests: requests),
      Error(value: final failure) => RequestLoadErrorState(
          error: failure.message,
        ),
    };
    setState(() {});
  }

  Future<void> acceptFriendshipRequest(FriendshipData friendshipData) async {
    final result = await showLoader(
      context,
      friendshipsService
          .acceptFriendshipRequest(friendshipData.friendships!.id),
    );
    resultToState(result, friendshipData);
  }

  Future<void> rejectFriendshipRequest(FriendshipData friendshipData) async {
    final result = await showLoader(
      context,
      friendshipsService.rejectFriendshipRequest(
        friendshipData.friendships!.id,
      ),
    );
    resultToState(result, friendshipData);
  }

  void resultToState(
    Result<void, Failure> result,
    FriendshipData friendshipData,
  ) {
    final data = switch (state) {
      RequestLoadedState(requests: final data) => data,
      _ => <FriendshipData>[],
    };
    final friendshipsData = switch (result) {
      Success() => [...data]..remove(friendshipData),
      Error() => data,
    };
    state = RequestLoadedState(requests: friendshipsData);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          const RequestsAppBar(),
          Expanded(
            child: switch (state) {
              RequestLoadingState() => const Center(
                  child: CircularProgressIndicator(),
                ),
              RequestLoadedState(requests: final requests)
                  when requests.isEmpty =>
                const Center(child: Text('No tienes solicitudes pendientes')),
              RequestLoadedState(requests: final requests) => UserList(
                  data: requests,
                  builder: (_, request) => RequestTile(
                    onAccept: () => acceptFriendshipRequest(request),
                    onReject: () => rejectFriendshipRequest(request),
                    username: request.user.username,
                    email: request.user.email,
                    photoUrl: request.user.photoUrl,
                  ),
                ),
              RequestLoadErrorState(error: final error) => Center(
                  child: Text(error),
                ),
            },
          ),
        ],
      ),
    );
  }
}
