import 'package:flutter/material.dart';
import 'package:monitoring_hamil/pages/home_page.dart';
import 'package:monitoring_hamil/pages/leaderboard_page.dart';
import 'package:monitoring_hamil/pages/profile_page.dart';

class PageControl extends StatefulWidget {
  PageControl({super.key});

  @override
  State<PageControl> createState() => _PageControlState();
}

class _PageControlState extends State<PageControl> {
  // selected pages indec
  int _selectedIndex = 0;

  // on item tap
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // pages list
  final List _pages = [
    // home page
    const HomePage(),
    // leaderboard page
    const LeaderboardPage(),
    // profile page
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        selectedItemColor: const Color.fromARGB(255, 252, 82, 0),
        unselectedItemColor: Colors.grey[900],
        selectedLabelStyle:
            const TextStyle(fontSize: 15.0), // Adjust the size as needed
        unselectedLabelStyle:
            const TextStyle(fontSize: 15.0), // Adjust the size as needed
        backgroundColor: const Color.fromARGB(255, 252, 255, 255),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 35.0), // Adjust the size as needed
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard,
                size: 35.0), // Adjust the size as needed
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 35.0), // Adjust the size as needed
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
