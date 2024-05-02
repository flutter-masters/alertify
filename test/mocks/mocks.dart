// ignore_for_file: subtype_of_sealed_class

// Firestore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {
  MockQueryDocumentSnapshot(this.id, this.dataMock);

  @override
  final String id;

  final Map<String, dynamic> dataMock;

  @override
  Map<String, dynamic> data() => dataMock;
}

class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {
  MockDocumentSnapshot(this.id, this.dataMock);

  @override
  final String id;

  final Map<String, dynamic> dataMock;

  @override
  Map<String, dynamic>? data() => dataMock;
}

// Firebase Auth

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}
