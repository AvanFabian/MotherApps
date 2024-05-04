import 'package:flutter/material.dart';
import 'package:monitoring_hamil/pages/home_page.dart';
import 'package:monitoring_hamil/pages/leaderboard_page.dart';
import 'package:monitoring_hamil/pages/route_page.dart';
import 'package:monitoring_hamil/pages/profile_page.dart';
import '../components/post_form.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
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
    // RoutePage(),
    const RoutePage(),
    // leaderboard page
    const LeaderboardPage(),
    // profile page
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: _pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _navigateBottomBar,
            selectedItemColor: const Color.fromARGB(255, 252, 82, 0),
            unselectedItemColor: Colors.grey[900],
            selectedLabelStyle: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500), // Adjust the size as needed
            unselectedLabelStyle: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500), // Adjust the size as needed
            backgroundColor: const Color.fromARGB(255, 252, 255, 255),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 32.0), // Adjust the size as needed
                label: 'Home',
              ),
              BottomNavigationBarItem(
                // maps icon
                icon: Icon(Icons.map, size: 32.0), // Adjust the size as needed
                label: 'Routes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.leaderboard,
                    size: 32.0), // Adjust the size as needed
                label: 'Leaderboard',
              ),
              BottomNavigationBarItem(
                icon:
                    Icon(Icons.person, size: 32.0), // Adjust the size as needed
                label: 'Profile',
              ),
            ],
          ),
        ),
        Positioned(
          right: 20, // Adjust this as needed
          bottom: 80, // Adjust this to change the vertical position
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PostForm(
                        title: 'Add new post',
                      )));
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
