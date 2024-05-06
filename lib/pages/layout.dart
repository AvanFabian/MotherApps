import 'package:flutter/material.dart';
import 'package:monitoring_hamil/pages/home_page.dart';
import 'package:monitoring_hamil/pages/leaderboard_page.dart';
import 'package:monitoring_hamil/pages/route_page.dart';
import 'package:monitoring_hamil/pages/profile_page.dart';
import 'package:monitoring_hamil/pages/record_page.dart';
import '../Components/AnyForm/post_form.dart';

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
    // record page
    const RecordPage(),
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
          bottomNavigationBar: _selectedIndex == 1 || _selectedIndex == 2
              ? null
              : BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: _navigateBottomBar,
                  // Selected item color
                  selectedItemColor: Colors.black87,
                  unselectedItemColor: Colors.black54,
                  // Text in the bottom navigation bar
                  showUnselectedLabels:
                      true, // hide labels for unselected items
                  selectedLabelStyle: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500), // Adjust the size as needed
                  unselectedLabelStyle: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500), // Adjust the size as needed
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home,
                          size: 28.0), // Adjust the size as needed
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      // maps icon
                      icon: Icon(Icons.map,
                          size: 28.0), // Adjust the size as needed
                      label: 'Routes',
                    ),
                    // Records Activity
                    BottomNavigationBarItem(
                      // record circle
                      icon: Icon(Icons.circle,
                          size: 28.0), // Adjust the size as needed
                      label: 'Record',
                    ),
                    BottomNavigationBarItem(
                      // trophy icon
                      icon: Icon(Icons.emoji_events,
                          size: 28.0), // Adjust the size as needed
                      label: 'Rank',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person,
                          size: 28.0), // Adjust the size as needed
                      label: 'Profile',
                    ),
                  ],
                ),
        ),
        Positioned(
          right: 20, // Adjust this as needed
          bottom: 80, // Adjust this to change the vertical position
          child: _selectedIndex == 0
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PostForm(
                              title: 'Add new post',
                            )));
                  },
                  // color of the button
                  backgroundColor: const Color.fromARGB(255, 255, 228, 0),
                  child: const Icon(Icons.add),
                )
              : Container(), // Empty container when not on HomePage
        ),
      ],
    );
  }
}
