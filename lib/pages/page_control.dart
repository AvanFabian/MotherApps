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
    HomePage(),
    // leaderboard page
    LeaderboardPage(),
    // profile page
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        backgroundColor: Colors.deepOrange[400],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black87),
            activeIcon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard, color: Colors.black87),
            activeIcon: Icon(Icons.leaderboard, color: Colors.white),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black87),
            activeIcon: Icon(Icons.person, color: Colors.white),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
