import 'package:charity_app/screens/projects/project_details.dart';
import 'package:charity_app/screens/projects/project_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllProjects extends StatelessWidget {
  const AllProjects({super.key});

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
                category: element['category'],
              ),
            );
          }

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
            getProjectCards(list)
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
  final Project data;
  const ProjectCard({super.key, required this.data});

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
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: Container(
              height: 125,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/food.png',
                      ),
                      fit: BoxFit.cover)),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 6, 0),
            child: Text(
              data.title.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                    data.description.toString(),
                    overflow: TextOverflow.clip,
                    maxLines: 2,
                  ),
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ProjectDetails(),
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

Widget getProjectCards(List<Project> data) {
  List<Widget> cards = <Widget>[];

  for (var i = 0; i < data.length; i++) {
    cards.add(ProjectCard(data: data[i]));
  }

  return Column(
    children: cards,
  );
}
