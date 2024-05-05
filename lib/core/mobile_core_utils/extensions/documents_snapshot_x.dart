import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../entities/app_user.dart';
import '../../../entities/emergency_alert.dart';
import '../../../entities/friendship.dart';
import '../typedefs/typedefs.dart';

extension DocumentSnapshotX on DocumentSnapshot<Json> {
  AppUser toAppUser() {
    return AppUser(
      id: id,
      email: this['email'],
      username: this['username'],
      photoUrl: this['photoUrl'],
    );
  }

  Friendship toFriendship() {
    return Friendship(
      id: id,
      status: FriendshipStatus.values.firstWhere(
        (element) => element.name == this['status'],
        orElse: () => FriendshipStatus.archived,
      ),
      createAt: DateTime.parse(this['createAt']),
      updateAt: DateTime.parse(this['updateAt']),
      sender: this['sender'],
      users: (this['users'] as List).map((e) => e.toString()).toList(),
    );
  }

  EmergencyAlert toEmergencyAlert() {
    return EmergencyAlert(
      id: id,
      sender: this['sender'],
      recipient: this['recipient'],
      createdAt: (this['createdAt'] as Timestamp).toDate(),
    );
  }
}
