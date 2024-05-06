import 'package:alertify/core/result.dart';
import 'package:alertify/features/friendship/data/services/friendship_service.dart';
import 'package:alertify/features/friendship/domain/repositories/friendship_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/fakes.dart';
import '../../../mocks/mocks.dart';

void main() {
  late FriendshipRepository repository;
  late FirebaseFirestore firestore;

  setUp(
    () {
      firestore = MockFirestore();
      repository = FriendshipService(firestore);
    },
  );

  group('Get Friends', () {
    test(
      'Get friend list with data',
      () async {
        final friendshipsCollectionRef = MockCollectionReference();
        final usersCollectionRef = MockCollectionReference();
        final mockFrienshipsStatusQuery = MockQuery();
        final mockFrienshipsUsersQuery = MockQuery();

        final mockUsersOrderQuery = MockQuery();
        final mockUsersWhereIdQuery = MockQuery();

        final mockFrienshipsQuerySnapshot = MockQuerySnapshot();
        final mockFriendshipsQueryDocumentSnapshot =
            MockQueryDocumentSnapshot();

        final mockUsersQuerySnaphot = MockQuerySnapshot();

        final mockUsersQueryDocumentSnapshot = MockQueryDocumentSnapshot();

        when(
          () => firestore.collection('friendships'),
        ).thenReturn(friendshipsCollectionRef);

        when(
          () => firestore.collection('users'),
        ).thenReturn(usersCollectionRef);

        when(
          () => friendshipsCollectionRef.where(
            'status',
            isEqualTo: any(named: 'isEqualTo'),
          ),
        ).thenReturn(mockFrienshipsStatusQuery);

        when(
          () => mockFrienshipsStatusQuery.where(
            'users',
            arrayContains: any(named: 'arrayContains'),
          ),
        ).thenReturn(mockFrienshipsUsersQuery);

        when(
          () => mockFrienshipsUsersQuery.get(),
        ).thenAnswer(
          (_) async => mockFrienshipsQuerySnapshot,
        );

        when(
          () => mockFrienshipsQuerySnapshot.docs,
        ).thenReturn(
          [
            mockFriendshipsQueryDocumentSnapshot,
          ],
        );

        when(
          () => mockFriendshipsQueryDocumentSnapshot.id,
        ).thenReturn('mockedId');

        when(
          () => mockFriendshipsQueryDocumentSnapshot.data(),
        ).thenReturn(fakeFriendshipMap);

        when(
          () => usersCollectionRef.orderBy('email'),
        ).thenReturn(mockUsersOrderQuery);

        when(
          () => mockUsersOrderQuery.where(
            'id',
            whereIn: any(named: 'whereIn'),
          ),
        ).thenReturn(mockUsersWhereIdQuery);

        when(
          () => mockUsersWhereIdQuery.get(),
        ).thenAnswer(
          (invocation) async {
            return mockUsersQuerySnaphot;
          },
        );

        when(
          () => mockUsersQuerySnaphot.docs,
        ).thenReturn(
          [
            mockUsersQueryDocumentSnapshot,
          ],
        );

        when(() => mockUsersQueryDocumentSnapshot.exists).thenReturn(true);
        when(() => mockUsersQueryDocumentSnapshot.id).thenReturn('asaassa');

        when(() => mockUsersQueryDocumentSnapshot.data()).thenReturn(
          fakeAppUserMap,
        );

        final result = await repository.getFriends('fakeUserId');
        expect(result, isA<Success>());
      },
    );

    test('Get friend list with empty data', () async {});

    test('Get friends and throw an error', () async {});
  });
}
