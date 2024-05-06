import 'package:alertify/core/result.dart';
import 'package:alertify/core/typedefs.dart';
import 'package:alertify/entities/app_user.dart';
import 'package:alertify/failures/failure.dart';
import 'package:alertify/features/profile/data/services/profile_service.dart';
import 'package:alertify/features/profile/domain/repositories/profile_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';

import '../../../mocks/fakes.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fakeFirebaseFirestore;
  late ProfileRepository profileRepository;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    fakeFirebaseFirestore = FakeFirebaseFirestore();

    profileRepository = ProfileService(mockFirebaseAuth, fakeFirebaseFirestore);
  });

  Future<void> seedDatabase() async => fakeFirebaseFirestore
      .collection('users')
      .doc(fakeUserSenderId)
      .set(fakeAppUserMap);

  group('Get profile data', () {
    test('Get profile info from Firestore', () async {
      // arrange
      await seedDatabase();

      // act
      final snapshot = await fakeFirebaseFirestore.collection('users').get();

      // assert
      expect(snapshot.docs.length, 1);
      expect(snapshot.docs.first.get('username'), fakeAppUser.username);
    });

    test('Get profile info from Firestore throws Exception', () async {
      // arrange
      await seedDatabase();

      final snapshot = await fakeFirebaseFirestore.collection('users').get();
      whenCalling(Invocation.method(#set, null))
          .on(snapshot)
          .thenThrow(FirebaseException(plugin: 'firestore'));

      // arrange
      expect(() => snapshot.docs.first.get('foo'), throwsA(isA<StateError>()));
    });

    test('Get profile information from profile repository', () async {
      // arrange
      await seedDatabase();

      // act
      final futureResult = profileRepository.userFromId(fakeUserSenderId);
      final result = await futureResult;

      // assert
      expect(futureResult, isA<FutureResult<AppUser>>());
      expect(result, isA<Success>());

      expect((result as Success).value, isA<AppUser>());
      expect(
        ((result as Success).value as AppUser).username,
        fakeAppUser.username,
      );
    });

    test('Get profile info from repository, not found', () async {
      // arrange
      await seedDatabase();

      // act
      final futureResult = profileRepository.userFromId('id');
      final result = await futureResult;

      // assert
      expect(futureResult, isA<FutureResult<AppUser>>());
      expect(result, isA<Err>());

      expect((result as Err).value, isA<Failure>());
      expect(((result as Err).value as Failure).message, 'User no found');
    });
  });

  group('Sign out', () {
    test('Sign out success', () async {
      // arrange
      mockFirebaseAuth.mockUser = fakeMockUser;

      // act
      final result = profileRepository.logout();

      // assert
      expect(result, isA<Future<void>>());
    });

    // JIC
    // test('Sign out with exception', () async {
    //   // arrange
    //   mockFirebaseAuth.mockUser = fakeMockUser;

    //   whenCalling(Invocation.method(#signOut, null))
    //       .on(mockFirebaseAuth)
    //       .thenThrow(FirebaseAuthException(code: 'signOutError'));

    //   // assert
    //   expect(
    //     () => mockFirebaseAuth.signOut(),
    //     throwsA(isA<FirebaseAuthException>()),
    //   );
    // });
  });
}
