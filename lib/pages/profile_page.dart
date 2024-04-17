import 'package:flutter/material.dart';
import 'package:monitoring_hamil/pages/page_control.dart'; // Replace with your package name
import 'package:monitoring_hamil/pages/leaderboard_page.dart'; // Replace with your package name

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Pengguna',
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
              // Handle the button's onPressed event
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Go to Home Page'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PageControl()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Go to Profile Page'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LeaderboardPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}