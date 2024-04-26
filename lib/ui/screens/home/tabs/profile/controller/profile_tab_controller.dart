import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/result.dart';
import '../../../../../../main.dart';
import '../../../../../../services/user_service.dart';

final profileDataProvider = FutureProvider.autoDispose((ref) async {
  final currentUserId = ref.watch(authRepoProvider).currentUserId;

  final userService = UserService(FirebaseFirestore.instance);
  final result = await userService.userFromId(currentUserId);

  return switch (result) {
    Success(value: final user) => user,
    Err(value: final failure) => throw Exception(failure.message),
  };
});

/*
  Hola gente. Desafortuadamente por tiempo no pudimos terminar este módulo.
  Sin embargo, aquí dejo esa parte finalizada.

  Abajo voy a dejar unos comentarios de cómo usar un AsyncValue diferente 
  al que se hizo con try/catch.

  Saludos: Fabián.
*/

enum LogoutStatus { none, sucess }

class LogoutController extends AutoDisposeAsyncNotifier<LogoutStatus> {
  @override
  FutureOr<LogoutStatus> build() => LogoutStatus.none;

  Future<void> logout() async {
    state = const AsyncValue.loading();

    // Esta es un alternativa de no usar el bloque de try/catch.
    // Ya el automáticamente toma la excepción y envía el
    // AsyncValue.error() o el AsyncError().
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepoProvider);
      await authRepo.logout();

      return LogoutStatus.sucess;
    });
  }
}

final logoutControllerProvider =
    AsyncNotifierProvider.autoDispose<LogoutController, LogoutStatus>(
  LogoutController.new,
);
