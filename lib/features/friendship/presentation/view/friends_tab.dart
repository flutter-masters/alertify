import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/mobile_core_utils/typedefs/typedefs.dart';
import '../../../../ui/screens/search/search_screen.dart';
import '../../../../ui/shared/dialogs/loader_dialog.dart';
import '../../../../ui/shared/extensions/build_context.dart';
import '../../../../ui/shared/widgets/user_list.dart';
import '../../../../ui/shared/widgets/user_tile.dart';
import '../controller/friendship_controller.dart';
import 'widgets/app_bar.dart';

class FriendsTab extends ConsumerWidget {
  const FriendsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendship = ref.watch(friendshipControllerProvider);

    ref.listen(
      friendshipControllerProvider.select((value) => value.hasError),
      (_, next) {},
    );

    return Material(
      color: context.theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          FriendsAppbar(onAdd: () => context.pushNamed(SearchScreen.route)),
          Expanded(
            child: switch (friendship) {
              AsyncData(value: final friends) when friends.isEmpty =>
                const Center(
                  child: Text('No tienes amigos...'),
                ),
              AsyncData(value: final friends) when friends.isNotEmpty =>
                UserList(
                  data: friends,
                  builder: (_, friendshipData) => UserTile(
                    onPressed: () => _onDelete(context, ref, friendshipData),
                    username: friendshipData.user.username,
                    email: friendshipData.user.email,
                  ),
                ),
              AsyncLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              AsyncError() => const Center(
                  child: Text('Oops you have an error'),
                ),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }

  Future<void> _onDelete(
    BuildContext context,
    WidgetRef ref,
    FriendshipData friendshipData,
  ) async {
    await showLoader(
      context,
      ref.read(friendshipControllerProvider.notifier).delete(friendshipData),
    );
  }
}
