import 'package:alertify/core/mobile_core_auth/user_repository.dart';
import 'package:alertify/core/mobile_core_auth/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart' as auth_mocks;
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/fakes.dart';

void main() {
  group('Get user data', () {
    late final auth_mocks.MockFirebaseAuth mockFirebaseAuth;
    late final UserRepository userRepository;

    setUpAll(() {
      mockFirebaseAuth = auth_mocks.MockFirebaseAuth();
      userRepository = UserService(mockFirebaseAuth);
    });

    test('Get current user', () async {
      // arrange
      const authCredential = AuthCredential(
        providerId: '',
        signInMethod: 'password',
      );
      mockFirebaseAuth.signInWithCredential(authCredential);
      mockFirebaseAuth.mockUser = fakeMockUser;

      // act
      final currentUser = userRepository.currentUserId;

      // assert
      expect(currentUser, fakeUserSenderId);
    });
  });
}
