import 'package:charity_app/screens/donation/donation_class.dart';
import 'package:charity_app/screens/donation/successful_donation.dart';
import 'package:charity_app/screens/projects/project_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProjectDetails extends StatefulWidget {
  //final Project project;
  final String projectId;
  const ProjectDetails({super.key, required this.projectId});

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  @override
  Widget build(BuildContext context) {
    CollectionReference project =
        FirebaseFirestore.instance.collection('projects');

    return FutureBuilder(
      future: project.doc(widget.projectId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
          var data = snapshot.data!;
          Project project = Project(
            id: widget.projectId,
            title: data["title"],
            description: data["description"],
            category: data["category"],
            currentDonation: (data["currentDonation"]).toDouble(),
            donationLimit: (data["donationLimit"]).toDouble(),
          );

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
                            const Flexible(
                              child: Icon(Icons.water_drop),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              project.title.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: LinearPercentIndicator(
                            animation: true,
                            lineHeight: 20.0,
                            animationDuration: 2000,
                            percent: percentageCalculator(
                                project.currentDonation, project.donationLimit),
                            center: Text(
                                "${project.currentDonation} / ${project.donationLimit}"),
                            barRadius: const Radius.circular(7),
                            progressColor: Colors.greenAccent,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          project.description,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DonationInput(
                          notifyParent: refresh,
                          project: project,
                        ),
                      ],
                    ),
                  ),
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

  refresh() {
    setState(() {});
  }
}

double percentageCalculator(currentDonation, donationLimit) {
  if (currentDonation > donationLimit) {
    return 1;
  }

  return currentDonation / donationLimit;
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

class DonationInput extends StatefulWidget {
  final Project project;
  final Function() notifyParent;
  const DonationInput(
      {super.key, required this.project, required this.notifyParent});

  @override
  State<DonationInput> createState() => _DonationInputState();
}

class _DonationInputState extends State<DonationInput> {
  TextEditingController _donationController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();
  late String _donationAmount = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _donationController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _donationAmount = "5.00";
                  _donationController.text = _donationAmount;
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: Text("£5"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _donationAmount = "10.00";
                  _donationController.text = _donationAmount;
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: Text("£10"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _donationAmount = "20.00";
                  _donationController.text = _donationAmount;
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: Text("£20"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _donationAmount = "50.00";
                  _donationController.text = _donationAmount;
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: Text("£50"),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration:
              (const BoxDecoration(border: Border(left: BorderSide(width: 3)))),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: SizedBox(
            height: 30,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(hintText: "Donation amount (£)"),
              style: const TextStyle(
                fontSize: 20,
              ),
              onChanged: (v) => setState(() {
                _donationAmount = v;
              }),
              controller: _donationController,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.only(left: 10),
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(width: 1),
              top: BorderSide(width: 1),
              right: BorderSide(width: 1),
            ),
          ),
          child: SizedBox(
            height: 150,
            child: TextField(
              maxLines: null, // Set this
              expands: true, // and this
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(hintText: "Reason for donation *"),
              controller: _reasonController,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              postProject(widget.project.id, widget.project.currentDonation,
                  _donationAmount);

              widget.notifyParent(); //refresh the parent widget

              String userId = getUser();

              Donation donation = Donation(
                  projectId: widget.project.id,
                  userId: userId,
                  reason: _reasonController.text,
                  timestamp: DateTime.now(),
                  amount: double.parse(_donationAmount));

              postDonation(donation);

              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const DonationSuccess()),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text('Donate now'),
          ),
        )
      ],
    );
  }
}

double updateDonation(currentDonation, donationAmount) {
  return currentDonation + double.parse(donationAmount);
}

String getUser() {
  final User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    String uid = user.uid;

    return uid;
  }
  return '';
}

void postProject(projectId, currentDonation, donationAmount) {
  FirebaseFirestore.instance.collection('projects').doc(projectId).update(
      {'currentDonation': updateDonation(currentDonation, donationAmount)});
}

void postDonation(Donation donation) {
  FirebaseFirestore db = FirebaseFirestore.instance;

  db
      .collection("donations")
      .add(donation.toMap())
      .catchError((error) => print('Error: ' + error));
}
