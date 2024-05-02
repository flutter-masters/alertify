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

    mockQueryDocumentSnapshotFriendship = MockQueryDocumentSnapshot(
      fakeFriendship.id,
      fakeFriendshipMap,
    );

    mockQueryDocumentSnapshotUser = MockQueryDocumentSnapshot(
      fakeAppUser.id,
      fakeAppUserMap,
    );

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
      // arrange
      whenFriendship();
      whenUser();

      // act
      final futureResult = friendshipRepository.getFriends(fakeAppUser.id);
      final result = await futureResult;

      // assert
      expect(futureResult, isA<FutureResult>());
      expect(
        result,
        isA<Success<List<FriendshipData>, Failure>>(),
      );
      expect((result as Success).value, [fakeFriendship]);

      verify(() => mockFirestore.collection(any()).doc(any())).called(1);
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
