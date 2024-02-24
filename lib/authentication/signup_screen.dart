import 'package:charity_app/authentication/auth_service.dart';
import 'package:charity_app/authentication/login_screen.dart';
import 'package:charity_app/home.dart';
import 'package:charity_app/screens/dashboard/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _auth = AuthService();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  //dispose controllers to avoid memory leak
  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: const AssetImage('assets/logo.png'),
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
                Text(
                  "Get Started",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Text(
                    "Fill out the form below to unlock the power of charity."),
                //Signup input form
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                              label: Text("Full Name"),
                              prefixIcon: Icon(Icons.person_3),
                              border: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          //sized boxes allow for space between widgets
                          height: 10,
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                              label: Text("Email"),
                              prefixIcon: Icon(Icons.mail_outline_rounded),
                              border: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              label: Text("Password"),
                              prefixIcon: Icon(Icons.fingerprint),
                              border: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _signUp,
                            child: const Text("SIGNUP"),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already registered?"),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text("Sign in"),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUp(email, password);

    if (user != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ),
      );
    }
  }
}
