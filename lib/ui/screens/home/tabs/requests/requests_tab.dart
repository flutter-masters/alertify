import 'package:flutter/material.dart';

import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/widgets/user_list.dart';
import 'widgets/app_bar.dart';
import 'widgets/request_tile.dart';

class RequestsTab extends StatelessWidget {
  const RequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          const RequestsAppBar(),
          Expanded(
            child: UserList(
              data: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
              builder: (_, data) => RequestTile(
                onAccept: () {},
                onReject: () => {},
                username: 'username',
                email: 'email',
                photoUrl: null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
