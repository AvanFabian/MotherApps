import 'package:monitoring_hamil/pages/post_page.dart';
// import 'package:monitoring_hamil/components/profile.dart';
// import 'package:monitoring_hamil/services/user_service.dart';
import 'package:flutter/material.dart';

// import '../components/Auth/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              // account icon
              icon: const Icon(Icons.account_circle, size: 35.0),
              color: const Color.fromARGB(255, 255, 255, 255),
              onPressed: () {
              },
            ),
          ],
        ),
        body: const Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 14.0, top: 16.0, right: 14.0, bottom: 32.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 8.0, top: 32.0, right: 8.0, bottom: 32.0),
                  // margin bottom
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text('Element 1'),
                          Text('Sub-element 1'),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Element 2'),
                          Text('Sub-element 2'),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Element 3'),
                          Text('Sub-element 3'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                child: PostPage()), // add Expanded to take up remaining space
          ],
        ));
  }
}
