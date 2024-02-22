class Project {
  final String id;
  final String title;
  final String description;
  final String category;
  final double currentDonation;
  final double donationLimit;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.currentDonation,
    required this.donationLimit,
  });
}
