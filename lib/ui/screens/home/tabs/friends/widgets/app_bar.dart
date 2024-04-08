import 'package:flutter/material.dart';

import '../../../../../shared/extensions/build_context.dart';

class FriendsAppbar extends StatelessWidget {
  const FriendsAppbar({
    super.key,
    required this.onAdd,
  });

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      title: const Text('My Friends'),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: onAdd,
          icon: const Icon(Icons.person_add),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
