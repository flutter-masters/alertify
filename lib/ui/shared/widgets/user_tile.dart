import 'package:flutter/material.dart';

import '../theme/palette.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.onPressed,
    this.trailingIcon = Icons.delete,
    required this.username,
    required this.email,
  });

  final VoidCallback onPressed;
  final IconData trailingIcon;
  final String username;
  final String email;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      tileColor: Palette.dark,
      leading: const CircleAvatar(),
      title: Text(username),
      subtitle: Text(email),
      trailing: IconButton(
        onPressed: onPressed,
        icon: Icon(trailingIcon),
      ),
    );
  }
}
