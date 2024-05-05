import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/mobile_core_utils/result/result.dart';
import '../../../../core/providers.dart';

final profileDataProvider = FutureProvider.autoDispose((ref) async {
  final currentUserId = ref.watch(userServiceProvider).currentUserId;
  final result = await ref.watch(profileServiceProvider).userFromId(
        currentUserId,
      );

  return switch (result) {
    Success(value: final user) => user,
    Err(value: final failure) => throw Exception(failure.message),
  };
});

enum LogoutStatus { none, sucess }

class LogoutController extends AutoDisposeAsyncNotifier<LogoutStatus> {
  @override
  FutureOr<LogoutStatus> build() => LogoutStatus.none;

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(profileServiceProvider).logout();
      return LogoutStatus.sucess;
    });
  }
}

final logoutControllerProvider =
    AsyncNotifierProvider.autoDispose<LogoutController, LogoutStatus>(
  LogoutController.new,
);
