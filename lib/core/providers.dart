import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/friendship/data/services/friendship_service.dart';
import '../features/friendship/domain/repositories/friendship_repository.dart';
import '../features/sign_in/data/services/sign_in_service.dart';
import '../features/sign_in/domain/repositories/sign_in_repository.dart';
import 'mobile_core_auth/user_repository.dart';
import 'mobile_core_auth/user_service.dart';

final signInServiceProvider = Provider<SignInRepository>(
  (_) => SignInService(FirebaseAuth.instance),
);

final userServiceProvider = Provider<UserRepository>(
  (_) => UserService(FirebaseAuth.instance),
);

final friendshipServiceProvider = Provider<FriendshipRepository>(
  (_) => FriendshipService(FirebaseFirestore.instance),
);
