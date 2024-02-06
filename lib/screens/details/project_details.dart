import 'package:flutter/material.dart';

class ProjectDetails extends StatelessWidget {
  const ProjectDetails({super.key});

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
            ImageCard(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF7F6F1),
              ),
              padding: const EdgeInsets.all(20),
              child: const Column(
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
                        "Give the gift of water",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'The "Pure Drops for Hope" initiative is a heartfelt charity project dedicated to providing clean drinking water to orphaned children in underprivileged communities worldwide. With a mission to ensure every childs basic right to safe hydration, the project establishes sustainable water purification systems and distributes portable water filtration kits to orphanages in need. Through collaborative efforts with local organizations and volunteers, Pure Drops for Hope not only delivers essential hydration but also empowers orphaned children with the knowledge of water sanitation and hygiene practices.',
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