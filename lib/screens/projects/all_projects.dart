import 'package:charity_app/authentication/login_screen.dart';
import 'package:charity_app/screens/donation/user_donations.dart';
import 'package:charity_app/screens/projects/project_details.dart';
import 'package:charity_app/screens/projects/project_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class AllProjects extends StatelessWidget {
  final String filter;
  const AllProjects({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    CollectionReference projects =
        FirebaseFirestore.instance.collection('projects');

    return FutureBuilder<QuerySnapshot>(
      future: projects.get(),
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
          List<Project> list = <Project>[];

          for (var element in snapshot.data!.docs) {
            list.add(
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
                  child: Column(children: [
                Container(
                  margin: const EdgeInsets.all(12),
                  height: 70,
                  width: double.infinity,
                  child: const Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    color: Colors.black,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Keep up to date with the latest projects from various charity organisations and find the one that resonates with you the most',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                getProjectCards(list, filter)
              ])));
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

class ProjectCard extends StatelessWidget {
  final Project project;
  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadImage(project.title),
      builder: (BuildContext context, AsyncSnapshot<String> image) {
        return Card(
          margin: const EdgeInsets.all(12),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          elevation: 4.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Container(
                  height: 125,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                            image.data.toString(),
                          ),
                          fit: BoxFit.cover)),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(12, 12, 6, 0),
                child: Text(
                  project.title.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
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
                        project.description.toString(),
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
                                projectId: project.id,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
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
      },
    );
  }
}

Widget getProjectCards(List<Project> data, filter) {
  List<Widget> cards = <Widget>[];

  for (var i = 0; i < data.length; i++) {
    if (filter != '') {
      if (data[i].category == filter) {
        //appl filters
        cards.add(ProjectCard(project: data[i]));
      }
    } else {
      cards.add(ProjectCard(project: data[i]));
    }
  }

  return Column(
    children: cards,
  );
}

Future<String> loadImage(title) async {
  String data = '';
  String path = title.replaceAll(' ', '').toLowerCase();
  Reference ref = FirebaseStorage.instance.ref().child("images/$path.jpg");

  try {
    data = await ref.getDownloadURL();
  } on FirebaseException {
    // Handle any errors.
    //print(e);
  }

  return data;
}
