import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/result.dart';
import '../../../../services/auth_service.dart';

enum SignInStatus { none, success }

class SignInController extends AutoDisposeAsyncNotifier<SignInStatus> {
  @override
  FutureOr<SignInStatus> build() => SignInStatus.none;

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();

    try {
      final authService = AuthService(FirebaseAuth.instance);

      final result = await authService.signIn(email: email, password: password);
      final failure = switch (result) {
        Success() => null,
        Error(value: final exception) => exception,
      };

      if (failure == null) {
        state = const AsyncData(SignInStatus.success);
      } else {
        state = AsyncError(failure, StackTrace.current);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final signInControllerProvider =
    AsyncNotifierProvider.autoDispose<SignInController, SignInStatus>(
  SignInController.new,
);
