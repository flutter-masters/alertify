import 'package:flutter/material.dart';

import '../../../../../shared/extensions/build_context.dart';

class RequestsAppBar extends StatelessWidget {
  const RequestsAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      centerTitle: false,
      title: const Text('Friend Requests'),
    );
  }
}
