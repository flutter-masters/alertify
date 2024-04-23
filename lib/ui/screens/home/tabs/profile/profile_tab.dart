import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../core/result.dart';
import '../../../../../entities/app_user.dart';
import '../../../../../services/auth_service.dart';
import '../../../../../services/user_service.dart';
import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/theme/palette.dart';
import '../../../auth/auth_screen.dart';

sealed class ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  ProfileLoadedState({required this.user});
  final AppUser user;
}

class ProfileLoadErrorState extends ProfileState {
  final String message;

  ProfileLoadErrorState({required this.message});
}

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  ProfileState state = ProfileLoadingState();
  final authService = AuthService(FirebaseAuth.instance);
  final userService = UserService(FirebaseFirestore.instance);
  late final currentUserId = authService.currentUserId;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => loadUser());
    super.initState();
  }

  Future<void> loadUser() async {
    setState(() => state = ProfileLoadingState());
    final result = await userService.userFromId(currentUserId);
    state = switch (result) {
      Success(value: final user) => ProfileLoadedState(user: user),
      Error(value: final failure) => ProfileLoadErrorState(
          message: failure.message,
        ),
    };
    setState(() {});
  }

  void logout() {
    authService.logout().whenComplete(
          () => context.pushNamedAndRemoveUntil(AuthScreen.route),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: switch (state) {
          ProfileLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
          ProfileLoadedState(user: final user) => Padding(
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
                    onPressed: logout,
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
          ProfileLoadErrorState(message: final message) => Center(
              child: Text(message),
            ),
        },
      ),
    );
  }
}
