class DonationHistory {
  final String projectId;
  final String projectName;
  final DateTime timestamp;
  final double amount;

  DonationHistory({
    required this.projectId,
    required this.projectName,
    required this.timestamp,
    required this.amount,
  });
}
