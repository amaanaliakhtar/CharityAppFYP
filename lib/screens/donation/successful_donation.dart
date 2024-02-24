import 'package:charity_app/screens/projects/all_projects.dart';
import 'package:flutter/material.dart';

class DonationSuccess extends StatelessWidget {
  const DonationSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage("assets/logo.png")),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Thanks for your donation!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const AllProjects(
                            filter: '',
                          )),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text('Return to projects'),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
