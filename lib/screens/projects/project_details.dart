import 'package:charity_app/screens/projects/project_class.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProjectDetails extends StatelessWidget {
  final Project project;
  const ProjectDetails({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageCard(
              projectTitle: project.title,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF7F6F1),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Icon(Icons.water_drop),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        project.title.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    project.description,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DonationAmountButton(donationAmount: "5"),
                      DonationAmountButton(donationAmount: "10"),
                      DonationAmountButton(donationAmount: "20"),
                      DonationAmountButton(donationAmount: "50"),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: (const BoxDecoration(
                        border: Border(left: BorderSide(width: 3)))),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Opacity(
                          opacity: 0.4,
                          child: Text(
                            "Donation amount",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ], //todo change opacity
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      child: Text('Donate now'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  final String projectTitle;
  const ImageCard({super.key, required this.projectTitle});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadImage(projectTitle),
        builder: (BuildContext context, AsyncSnapshot<String> image) {
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            elevation: 3,
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(15.0), //needed to make card rounded
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                            image.data.toString(),
                          ),
                          fit: BoxFit.cover)),
                ),
              ),
            ),
          );
        });
  }
}

class DonationAmountButton extends StatelessWidget {
  final String donationAmount;
  const DonationAmountButton({super.key, required this.donationAmount});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
      child: Text('£' + donationAmount),
    );
  }
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
