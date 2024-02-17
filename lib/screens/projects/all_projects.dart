import 'package:charity_app/screens/projects/project_details.dart';
import 'package:charity_app/screens/projects/project_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

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
                title: element['title'],
                description: element['description'],
                visible: element['visible'],
                order: element['order'],
              ),
            );
          }

          list.sort((a, b) => a.order.compareTo(b.order)); //sorts list by order

          return Scaffold(
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
                color: Colors.blue,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Keep up to date with the latest news and information regarding the masjid.',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            //getInformationCards(list)
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
  const ProjectCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
