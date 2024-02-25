import 'package:charity_app/authentication/login_screen.dart';
import 'package:charity_app/screens/donation/donation_class.dart';
import 'package:charity_app/screens/donation/donation_history_class.dart';
import 'package:charity_app/screens/projects/project_class.dart';
import 'package:charity_app/screens/projects/project_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class MyDonations extends StatelessWidget {
  const MyDonations({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference donations =
        FirebaseFirestore.instance.collection('donations');
    CollectionReference projects =
        FirebaseFirestore.instance.collection('projects');
    List<String> projectIds = <String>[];
    List<Donation> donationList = <Donation>[];
    List<Project> projectList = <Project>[];

    String userId = getUser();

    return FutureBuilder<QuerySnapshot>(
      future: donations.where("userId", isEqualTo: userId).get(),
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
          for (var element in snapshot.data!.docs) {
            donationList.add(
              Donation(
                projectId: element['projectId'],
                userId: element['userId'],
                reason: element['reason'],
                timestamp: (element['timestamp']).toDate(),
                amount: (element['amount']).toDouble(),
              ),
            );
          }

          projectIds =
              projectIds.toSet().toList(); //remove duplicates from list

          return FutureBuilder(
            future: projects.get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                for (var element in snapshot.data!.docs) {
                  projectList.add(
                    Project(
                      id: element.id,
                      title: element['title'],
                      description: element['description'],
                      category: element['category'],
                      donationLimit: (element['donationLimit']).toDouble(),
                      currentDonation: (element['currentDonation']).toDouble(),
                    ),
                  );
                }

                return Scaffold(
                  appBar: AppBar(
                    iconTheme: IconThemeData(
                      color: Colors.black,
                    ),
                    title: const Text(
                      "Charity Navigator",
                      style: TextStyle(color: Colors.black),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MyDonations(),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.book,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                actions: [
                                  SignedOutAction((context) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => LoginScreen(),
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.person,
                        ),
                      )
                    ],
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(12),
                          height: 70,
                          width: double.infinity,
                          child: const Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            color: Colors.black,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'History of your past donations - thank you for your generosity!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        getProjectCards(projectList, donationList)
                      ],
                    ),
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

class HistoryCard extends StatelessWidget {
  final DonationHistory history;
  const HistoryCard({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 6, 0),
            child: Text(
              history.projectName.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 6, 0),
            child: Text(
              'You donated £' + history.amount.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            alignment: Alignment.centerLeft,
            height: 75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    history.timestamp.toString(),
                    overflow: TextOverflow.clip,
                    maxLines: 2,
                  ),
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProjectDetails(
                            projectId: history.projectId,
                          ),
                        ),
                      );
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                    ),
                  ),
                ),
              ],
            ),
          ), //info
        ],
      ),
    );
  }
}

Widget getProjectCards(List<Project> projects, List<Donation> donations) {
  List<Widget> cards = <Widget>[];
  List<DonationHistory> history = <DonationHistory>[];

  for (var d in donations) {
    for (var p in projects) {
      if (p.id == d.projectId) {
        history.add(DonationHistory(
            projectId: p.id,
            projectName: p.title,
            timestamp: d.timestamp,
            amount: d.amount));
      }
    }
  }

  for (var i = 0; i < history.length; i++) {
    cards.add(HistoryCard(history: history[i]));
  }

  return Column(
    children: cards,
  );
}
