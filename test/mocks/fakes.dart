import 'package:alertify/entities/app_user.dart';
import 'package:alertify/entities/friendship.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

const fakeUserId = 'fakeId';

const fakeUserSenderId = 'senderId';

const fakeAppUser = AppUser(
  id: fakeUserId,
  email: 'prueba@prueba.com',
  username: 'MiUsuarioDePrueba',
  photoUrl: null,
);

final fakeAppUserMap = <String, dynamic>{
  'id': fakeUserId,
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
  'users': [fakeUserSenderId, fakeUserId],
};

final fakeFriendship = Friendship(
  id: '4ngD7wvVmxodLesJa3HQ',
  status: FriendshipStatus.active,
  createAt: dateNow,
  updateAt: dateNow,
  sender: 'senderId',
  users: [fakeUserSenderId, fakeUserId],
);

final fakeMockUser = MockUser(
  isAnonymous: false,
  uid: fakeUserSenderId,
  email: fakeAppUser.email,
  displayName: fakeAppUser.username,
);
