import 'package:alertify/core/result.dart';
import 'package:alertify/core/typedefs.dart';
import 'package:alertify/failures/auth_failure.dart';
import 'package:alertify/features/sign_in/data/services/sign_in_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  late SignInService signInService;

  setUpAll(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();

    signInService = SignInService(mockFirebaseAuth);
  });

  group('Sign In user', () {
    test('Sign in user with email and password', () async {
      // arrange
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => mockUserCredential);

      when(() => mockUserCredential.user).thenReturn(mockUser);

      // act
      final futureResult = signInService.signIn(
        email: 'prueba@prueba.com',
        password: '123456',
      );
      final result = await futureResult;

      // assert
      expect(futureResult, isA<FutureAuthResult<void, SignInAuthFailure>>());
      expect(result, isA<void>());

      verify(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).called(1);
    });

    test('Sign in user with email and password and gets null', () async {
      // arrange
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => mockUserCredential);

      when(() => mockUserCredential.user).thenReturn(null);

      // act
      final futureResult = signInService.signIn(
        email: 'prueba@prueba.com',
        password: '123456',
      );
      final result = await futureResult;

      // assert
      expect(futureResult, isA<FutureAuthResult<void, SignInAuthFailure>>());
      expect(result, isA<Err<void, SignInAuthFailure>>());
      expect((result as Err).value, SignInAuthFailure.userNotFound);

      verify(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).called(1);
    });

    test('Sign in user and throws a FirebaseAuthException', () async {
      // arrange
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      // act
      final futureResult = signInService.signIn(
        email: 'prueba@prueba.com',
        password: '123456',
      );
      final result = await futureResult;

      // assert
      expect(futureResult, isA<FutureAuthResult<void, SignInAuthFailure>>());
      expect(result, isA<Err<void, SignInAuthFailure>>());
      expect((result as Err).value, SignInAuthFailure.wrongPassword);

      verify(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).called(1);
    });

    test('Sign in user and throws a Exception', () async {
      // arrange
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception('Oops!!!'));

      // act
      final futureResult = signInService.signIn(
        email: 'prueba@prueba.com',
        password: '123456',
      );
      final result = await futureResult;

      // assert
      expect(futureResult, isA<FutureAuthResult<void, SignInAuthFailure>>());
      expect(result, isA<Err<void, SignInAuthFailure>>());
      expect((result as Err).value, SignInAuthFailure.unknown);

      verify(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).called(1);
    });
  });
}
