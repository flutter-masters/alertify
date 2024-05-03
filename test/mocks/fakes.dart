import 'package:alertify/entities/app_user.dart';
import 'package:alertify/entities/friendship.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

const fakeUserSenderId = 'senderId';

const fakeAppUser = AppUser(
  id: 'id',
  email: 'prueba@prueba.com',
  username: 'MiUsuarioDePrueba',
  photoUrl: null,
);

final fakeAppUserMap = <String, dynamic>{
  'email': 'prueba@prueba.com',
  'username': 'MiUsuarioDePrueba',
  'photoUrl': null,
};

final dateNow = DateTime.now();

final fakeFriendshipMap = <String, dynamic>{
  'status': FriendshipStatus.active.name,
  'createAt': dateNow.toIso8601String(),
  'updateAt': dateNow.toIso8601String(),
  'sender': 'senderId',
  'users': ['senderId'],
};

final fakeFriendship = Friendship(
  id: '4ngD7wvVmxodLesJa3HQ',
  status: FriendshipStatus.active,
  createAt: dateNow,
  updateAt: dateNow,
  sender: 'senderId',
  users: ['senderId'],
);

final fakeMockUser = MockUser(
  isAnonymous: false,
  uid: fakeUserSenderId,
  email: fakeAppUser.email,
  displayName: fakeAppUser.username,
);
