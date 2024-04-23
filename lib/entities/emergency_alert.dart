class EmergencyAlert {
  EmergencyAlert({
    required this.id,
    required this.sender,
    required this.recipient,
    required this.createdAt,
  });

  final String id;
  final String sender;
  final String recipient;
  final DateTime createdAt;
}
