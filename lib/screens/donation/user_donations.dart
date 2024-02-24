import 'package:charity_app/screens/donation/donation_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDonations extends StatelessWidget {
  const MyDonations({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference projects =
        FirebaseFirestore.instance.collection('donations');

    String userId = getUser();

    return FutureBuilder<QuerySnapshot>(
      future: projects.where("userId", isEqualTo: userId).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/icons/warning.png'),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Error Loading Information',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )
                ],
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          List<Donation> list = <Donation>[];

          for (var element in snapshot.data!.docs) {
            list.add(
              Donation(
                projectId: element['projectId'],
                userId: element['userId'],
                reason: element['reason'],
                timestamp: (element['timestamp']).toDate(),
                amount: (element['amount']).toDouble(),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              leading: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
              title: const Text(
                "Charity Navigator",
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(list[index].projectId),
                  tileColor: Colors.black,
                  textColor: Colors.white,
                );
              },
              itemCount: list.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Colors.white,
                );
              },
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Loading...',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String getUser() {
  final User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    String uid = user.uid;

    return uid;
  }
  return '';
}
