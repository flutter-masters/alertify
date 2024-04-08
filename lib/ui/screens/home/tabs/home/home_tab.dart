import 'package:flutter/material.dart';

import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/theme/palette.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: SizedBox(
              width: 120,
              height: 120,
              child: Material(
                color: Palette.green,
                child: InkWell(
                  onLongPress: () {},
                  child: const Icon(Icons.sos, size: 70),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Keep the button pressed to send an alert.'),
        ],
      ),
    );
  }
}
