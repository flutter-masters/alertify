import 'package:alertify/core/mobile_core_auth/user_repository.dart';
import 'package:alertify/core/mobile_core_auth/user_service.dart';
import 'package:alertify/core/providers.dart';
import 'package:alertify/features/profile/data/services/profile_service.dart';
import 'package:alertify/features/profile/domain/repositories/profile_repository.dart';
import 'package:alertify/features/profile/presentation/view/profile_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';

import '../../../../mocks/fakes.dart';

void main() {
  group('Profile Tab', () {
    late final FakeFirebaseFirestore mockFirestore;
    late final MockFirebaseAuth mockFirebaseAuth;

    late final UserRepository mockUserService;
    late final ProfileRepository mockProfileService;

    setUpAll(() {
      mockFirestore = FakeFirebaseFirestore();
      mockFirebaseAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: fakeMockUser,
      );

      mockUserService = UserService(mockFirebaseAuth);
      mockProfileService = ProfileService(mockFirebaseAuth, mockFirestore);
    });

    Future<void> seedDatabase() async => mockFirestore
        .collection('users')
        .doc(fakeUserSenderId)
        .set(fakeAppUserMap);

    Future<void> pumpMainWidget(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userServiceProvider.overrideWithValue(mockUserService),
            profileServiceProvider.overrideWithValue(mockProfileService),
          ],
          child: const MaterialApp(
            home: ProfileTab(),
          ),
        ),
      );
    }

    testWidgets('Get profile data', (tester) async {
      // arrange
      seedDatabase();
      await pumpMainWidget(tester);

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(CircleAvatar), findsNothing);

      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    // TODO: Pending to review is Failing when run in group
    testWidgets('Get Error when get profile data', (tester) async {
      // arrange
      final snapshot = await mockFirestore.collection('users').get();
      whenCalling(Invocation.method(#get, null))
          .on(snapshot)
          .thenThrow(FirebaseException(plugin: 'firestore'));

      await pumpMainWidget(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(CircleAvatar), findsNothing);

      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Oops you have an error'), findsOneWidget);
    });
  });
}
