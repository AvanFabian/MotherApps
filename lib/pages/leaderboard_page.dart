import 'package:flutter/material.dart';
import 'package:monitoring_hamil/pages/home_page.dart'; // Replace with your package name
import 'package:monitoring_hamil/pages/profile_page.dart'; // Replace with your package name

class LeaderboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard Page'),
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
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Go to Profile Page'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}