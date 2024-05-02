import 'package:alertify/core/result.dart';
import 'package:alertify/core/typedefs.dart';
import 'package:alertify/extensions/documents_snapshot_x.dart';
import 'package:alertify/failures/failure.dart';
import 'package:alertify/features/friendship/data/services/friendship_service.dart';
import 'package:alertify/features/friendship/domain/repositories/friendship_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/fakes.dart';
import '../../../mocks/mocks.dart';

void main() {
  late MockFirestore mockFirestore;

  late MockCollectionReference mockCollectionReference;
  late MockQuery mockQuery;
  late MockQuerySnapshot mockQuerySnapshot;

  late MockQueryDocumentSnapshot mockQueryDocumentSnapshotFriendship;
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshotUser;

  late FriendshipRepository friendshipRepository;

  setUpAll(() {
    mockFirestore = MockFirestore();

    mockCollectionReference = MockCollectionReference();

    mockQuery = MockQuery();
    mockQuerySnapshot = MockQuerySnapshot();

    mockQueryDocumentSnapshotFriendship = MockQueryDocumentSnapshot();

    mockQueryDocumentSnapshotUser = MockQueryDocumentSnapshot();

    friendshipRepository = FriendshipService(mockFirestore);
  });

  void whenFriendship({bool isEmptyData = false}) {
    when(() => mockFirestore.collection('friendships')).thenReturn(
      mockCollectionReference,
    );

    when(
      () => mockCollectionReference.where(
        'status',
        isEqualTo: any(named: 'isEqualTo'),
      ),
    ).thenReturn(mockQuery);

    when(
      () => mockQuery.where(
        'users',
        arrayContains: any(named: 'arrayContains'),
      ),
    ).thenReturn(mockQuery);

    when(() => mockQuery.get()).thenAnswer(
      (_) async => mockQuerySnapshot,
    );

    if (!isEmptyData) {
      when(() => mockQuerySnapshot.docs).thenReturn(
        [mockQueryDocumentSnapshotFriendship],
      );

      when(() => mockQueryDocumentSnapshotFriendship.toFriendship()).thenReturn(
        fakeFriendship,
      );
    } else {
      when(() => mockQuerySnapshot.docs).thenReturn([]);
    }
  }

  void whenUser({bool hasError = false}) {
    when(() => mockFirestore.collection('users')).thenReturn(
      mockCollectionReference,
    );

    when(() => mockCollectionReference.orderBy('email')).thenReturn(
      mockQuery,
    );

    when(
      () => mockQuery.where(
        'id',
        whereIn: any(named: 'whereIn'),
      ),
    ).thenReturn(mockQuery);

    when(() => mockQuery.get()).thenAnswer(
      (_) async => mockQuerySnapshot,
    );

    when(() => mockQuerySnapshot.docs).thenReturn(
      [mockQueryDocumentSnapshotUser],
    );

    if (!hasError) {
      when(() => mockQueryDocumentSnapshotUser.exists).thenReturn(true);
      when(() => mockQueryDocumentSnapshotUser.toAppUser()).thenReturn(
        fakeAppUser,
      );
    } else {
      when(() => mockQueryDocumentSnapshotUser.toAppUser()).thenThrow(
        Exception('Oops!! Error getting friends'),
      );
    }
  }

  group('Get Friends', () {
    test('Get friend list with data', () async {
      // act

      final mockCollectionFriendshipsReference = MockCollectionReference();
      final mockCollectionUsersReference = MockCollectionReference();

      when(() => mockFirestore.collection('friendships')).thenReturn(
        mockCollectionFriendshipsReference,
      );
      when(() => mockFirestore.collection('users')).thenReturn(
        mockCollectionUsersReference,
      );

      final mockUsersQuery = MockQuery();

      when(
        () => mockCollectionFriendshipsReference.where(
          'status',
          isEqualTo: any(named: 'isEqualTo'),
        ),
      ).thenAnswer(
        (invocation) {
          return mockQuery;
        },
      );

      when(
        () => mockQuery.where(
          'users',
          arrayContains: any(named: 'arrayContains'),
        ),
      ).thenReturn(mockUsersQuery);

      when(
        () => mockUsersQuery.get(),
      ).thenAnswer(
        (_) async {
          return mockQuerySnapshot;
        },
      );

      when(
        () => mockQuerySnapshot.docs,
      ).thenAnswer(
        (_) {
          return [
            mockQueryDocumentSnapshotFriendship,
          ];
        },
      );

      when(
        () => mockQueryDocumentSnapshotFriendship.id,
      ).thenReturn('fakeId');

      when(
        () => mockQueryDocumentSnapshotFriendship.data(),
      ).thenReturn(fakeFriendshipMap);

      final mockUsersQueryOrderBy = MockQuery();
      final mockUsersQueryWhereIn = MockQuery();
      final mockUsersQuerySnapshot = MockQuerySnapshot();

      when(
        () => mockCollectionUsersReference.orderBy(any()),
      ).thenReturn(mockUsersQueryOrderBy);

      when(
        () => mockUsersQueryOrderBy.where(
          'id',
          whereIn: any(named: 'whereIn'),
        ),
      ).thenReturn(mockUsersQueryWhereIn);

      when(
        () => mockUsersQueryWhereIn.get(),
      ).thenAnswer(
        (_) async => mockUsersQuerySnapshot,
      );

      when(
        () => mockUsersQuerySnapshot.docs,
      ).thenReturn(
        [
          mockQueryDocumentSnapshotUser,
        ],
      );

      when(
        () => mockQueryDocumentSnapshotUser.id,
      ).thenReturn('fakeUserId');

      when(
        () => mockQueryDocumentSnapshotUser.exists,
      ).thenReturn(true);

      when(
        () => mockQueryDocumentSnapshotUser.data(),
      ).thenReturn(fakeAppUserMap);

      final futureResult = friendshipRepository.getFriends(fakeAppUser.id);
      final result = await futureResult;

      // assert
      expect(futureResult, isA<FutureResult>());
      expect(
        result,
        isA<Success<List<FriendshipData>, Failure>>(),
      );
      // expect((result as Success).value, [fakeFriendship]);
    });

    test('Get friend list with empty data', () async {
      // arrange
      whenFriendship(isEmptyData: true);

      // act
      final futureResult = friendshipRepository.getFriends(fakeAppUser.id);
      final result = await futureResult;

      // assert
      expect(futureResult, isA<FutureResult>());
      expect(
        result,
        isA<Success<List<FriendshipData>, Failure>>(),
      );
      expect((result as Success).value, []);

      verify(() => mockFirestore.collection(any()).doc(any())).called(1);
    });

    test('Get friends and throw an error', () async {
      // arrange
      whenFriendship();
      whenUser(hasError: true);

      // act
      final futureResult = friendshipRepository.getFriends(fakeAppUser.id);
      final result = await futureResult;

      // assert
      expect(futureResult, isA<FutureResult>());
      expect(
        result,
        isA<Err<List<FriendshipData>, Failure>>(),
      );
      expect((result as Err).value.message, 'Oops!! Error getting friends');

      verify(() => mockFirestore.collection(any()).doc(any())).called(1);
    });
  });
}
