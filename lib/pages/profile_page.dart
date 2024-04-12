import 'package:flutter/material.dart';
import 'package:monitoring_hamil/pages/page_control.dart'; // Replace with your package name
import 'package:monitoring_hamil/pages/leaderboard_page.dart'; // Replace with your package name

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
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