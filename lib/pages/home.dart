import 'package:monitoring_hamil/components/post_screen.dart';
import 'package:monitoring_hamil/components/profile.dart';
// import 'package:monitoring_hamil/services/user_service.dart';
import 'package:flutter/material.dart';

import '../components/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0, // Adjust the size as needed
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 252, 82, 0),
        elevation: 0, // z-coordinate of the app bar
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_add, size: 35.0),
            color: const Color.fromARGB(255, 255, 255, 255),
            onPressed: () {
              // navigate to Login
              Navigator.of(context).pushAndRemoveUntil(
                // ignore: prefer_const_constructors
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: currentIndex == 0 ? const PostScreen() : const Profile(),
    );
  }
}
