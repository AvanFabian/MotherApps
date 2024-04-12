import 'package:flutter/material.dart';
import 'package:monitoring_hamil/pages/home_page.dart'; // Replace with your package name
import 'package:monitoring_hamil/pages/profile_page.dart'; // Replace with your package name

class LeaderboardPage extends StatelessWidget {
  LeaderboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Papan Peringkat')),
        backgroundColor: Colors.deepOrange[400],
        elevation: 0, // z-coordinate of the app bar
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        // logout button
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {},
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
