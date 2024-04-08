import 'package:flutter/material.dart';

import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/widgets/user_list.dart';
import '../../../../shared/widgets/user_tile.dart';
import '../../../search/search_screen.dart';
import 'widgets/app_bar.dart';

class FriendsTab extends StatelessWidget {
  const FriendsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          FriendsAppbar(onAdd: () => context.pushNamed(SearchScreen.route)),
          Expanded(
            child: UserList(
              data: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
              builder: (_, data) => UserTile(
                onPressed: () {},
                username: 'username',
                email: 'email',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
