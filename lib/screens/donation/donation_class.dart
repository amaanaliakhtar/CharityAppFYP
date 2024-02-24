class Donation {
  final String projectId;
  final String userId;
  final String reason;
  final DateTime timestamp;
  final double amount;

  Donation(
      {required this.projectId,
      required this.userId,
      required this.reason,
      required this.timestamp,
      required this.amount});

  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'userId': userId,
      'reason': reason,
      'timestamp': timestamp,
      'amount': amount
    };
  }
}
