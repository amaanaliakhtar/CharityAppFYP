import 'package:cloud_firestore/cloud_firestore.dart';

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

  // factory Project.fromFirestore(
  //   DocumentSnapshot<Map<String, dynamic>> snapshot,
  //   SnapshotOptions? options,
  // ) {
  //   final data = snapshot.data();
  //   return Project(
  //     id: data?['id'],
  //     title: data?['title'],
  //     description: data?['description'],
  //     category: data?['category'],
  //     currentDonation: data?['currentDonation'],
  //     donationLimit: data?['donationLimit'],
  //   );
  // }

  // Map<String, dynamic> toFirestore() {
  //   return {
  //     if (title != null) "title": title,
  //     if (description != null) "description": description,
  //     if (category != null) "category": category,
  //     if (currentDonation != null) "currentDonation": currentDonation,
  //     if (donationLimit != null) "donationLimit": donationLimit,
  //   };
  // }
}
