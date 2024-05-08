import 'package:alertify/core/mobile_core_auth/user_repository.dart';
import 'package:alertify/core/mobile_core_auth/user_service.dart';
import 'package:alertify/core/providers.dart';
import 'package:alertify/features/friendship/data/services/friendship_service.dart';
import 'package:alertify/features/friendship/domain/repositories/friendship_repository.dart';
import 'package:alertify/features/friendship/presentation/view/friends_tab.dart';
import 'package:alertify/ui/shared/widgets/user_list.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';

import '../../../../mocks/fakes.dart';

void main() {
  group('Friends Tab', () {
    late final FakeFirebaseFirestore mockFirestore;
    late final MockFirebaseAuth mockFirebaseAuth;

    late final UserRepository mockUserService;
    late final FriendshipRepository mockFriendshipService;

    setUpAll(() {
      mockFirestore = FakeFirebaseFirestore();
      mockFirebaseAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: fakeMockUser,
      );

      mockUserService = UserService(mockFirebaseAuth);
      mockFriendshipService = FriendshipService(mockFirestore);
    });

    Future<void> seedDatabase({bool isEmpty = false}) async {
      await mockFirestore
          .collection('users')
          .doc(fakeAppUser.id)
          .set(fakeAppUserMap);

      await mockFirestore
          .collection('friendships')
          .doc(fakeFriendship.id)
          .set(isEmpty ? {} : fakeFriendshipMap);
    }

    Future<void> pumpMainWidget(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userServiceProvider.overrideWithValue(mockUserService),
            friendshipServiceProvider.overrideWithValue(mockFriendshipService),
          ],
          child: const MaterialApp(
            home: FriendsTab(),
          ),
        ),
      );
    }

    testWidgets('Get friend list', (tester) async {
      // arrange
      await seedDatabase();
      await pumpMainWidget(tester);

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(ListView), findsNothing);

      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Get empty friend list', (tester) async {
      // arrange
      await seedDatabase(isEmpty: true);
      await pumpMainWidget(tester);

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(UserList), findsNothing);

      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('No tienes amigos...'), findsOneWidget);
    });

    // TODO: Pending to review is Failing
    testWidgets('Get error when get friend list', (tester) async {
      // arrange
      await seedDatabase();

      final snapshot = await mockFirestore.collection('users').get();
      whenCalling(Invocation.method(#get, null))
          .on(snapshot)
          .thenThrow(FirebaseException(plugin: 'firestore'));

      await pumpMainWidget(tester);

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(UserList), findsNothing);

      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Oops you have an error'), findsOneWidget);
    });
  });
}
