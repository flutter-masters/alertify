import 'package:firebase_auth/firebase_auth.dart';

import 'user_repository.dart';

class UserService implements UserRepository {
  const UserService(this.client);

  final FirebaseAuth client;

  @override
  String get currentUserId => client.currentUser!.uid;

  @override
  bool get logged => client.currentUser != null;
}
