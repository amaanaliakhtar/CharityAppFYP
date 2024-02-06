import 'package:flutter/material.dart';

class ProjectDetails extends StatelessWidget {
  const ProjectDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageCard(),
          ],
        ),
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
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
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/orphans.jpg'),
                    fit: BoxFit.cover)),
          ),
        ),
      ),
    );
  }
}
