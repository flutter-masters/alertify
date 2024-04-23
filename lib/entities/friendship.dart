class Friendship {
  const Friendship({
    required this.id,
    required this.status,
    required this.createAt,
    required this.updateAt,
    required this.sender,
    required this.users,
  });

  final String id;
  final FriendshipStatus status;
  final DateTime createAt;
  final DateTime updateAt;
  final String sender;
  final List<String> users;
}

enum FriendshipStatus { pending, active, archived }
