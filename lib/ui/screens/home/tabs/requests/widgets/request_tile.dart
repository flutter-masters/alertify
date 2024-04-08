import 'package:flutter/material.dart';

import '../../../../../shared/theme/palette.dart';

class RequestTile extends StatelessWidget {
  const RequestTile({
    super.key,
    required this.onAccept,
    required this.onReject,
    required this.username,
    required this.email,
    required this.photoUrl,
  });

  final VoidCallback onAccept;
  final VoidCallback onReject;
  final String username;
  final String email;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      tileColor: Palette.dark,
      leading: const CircleAvatar(),
      title: Text(username),
      subtitle: Text(email),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onAccept,
            icon: const Icon(Icons.check, color: Palette.green),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: onAccept,
            icon: const Icon(Icons.close, color: Palette.pink),
          ),
        ],
      ),
    );
  }
}
