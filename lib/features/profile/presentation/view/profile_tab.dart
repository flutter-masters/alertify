import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../ui/shared/extensions/build_context.dart';
import '../../../../ui/shared/theme/palette.dart';
import '../../../auth/presentation/view/auth_screen.dart';
import '../controller/profile_tab_controller.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileData = ref.watch(profileDataProvider);

    ref.listen(logoutControllerProvider, (_, next) {
      next.whenOrNull(
        data: (data) {
          if (data == LogoutStatus.sucess) {
            context.pushNamedAndRemoveUntil(AuthScreen.route);
          }
        },
      );
    });

    return Material(
      color: context.theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: profileData.when(
          data: (user) => Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),
                const CircleAvatar(radius: 50),
                const SizedBox(height: 10),
                Text(
                  user.username,
                  textAlign: TextAlign.center,
                ),
                Text(
                  user.email,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: Palette.darkGray,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    ref.read(logoutControllerProvider.notifier).logout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.darkGray,
                  ),
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(color: Palette.pink),
                  ),
                ),
              ],
            ),
          ),
          error: (_, __) => const Center(
            child: Text('Oops you have an error'),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
