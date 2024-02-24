import 'package:charity_app/authentication/login_screen.dart';
import 'package:charity_app/screens/dashboard/dashboard.dart';
import 'package:charity_app/screens/donation/user_donations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPage = 0;
  List<Widget> pages = [
    Dashboard(),
    ProfileScreen(
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
    MyDonations()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: pages[currentPage],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(
              icon: Icon(Icons.assignment), label: 'Donations')
        ],
        onDestinationSelected: (int index) {
          setState(
            () {
              currentPage = index;
            },
          );
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
