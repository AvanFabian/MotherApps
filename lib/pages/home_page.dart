import 'package:monitoring_hamil/pages/post_page.dart';
// import 'package:monitoring_hamil/components/profile.dart';
// import 'package:monitoring_hamil/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:monitoring_hamil/constants.dart';
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
              color: Colors.black,
              fontSize: 24.0, // Adjust the size as needed
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: signatureAppColor,
          elevation: 0, // z-coordinate of the app bar
          actions: <Widget>[
            IconButton(
              // account icon
              icon: const Icon(Icons.account_circle, size: 35.0),
              color: Colors.black,
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              // background color
              padding: const EdgeInsets.only(
                  left: 4.0, top: 16.0, right: 4.0, bottom: 16.0),
              child: Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                // border radius
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(
                      left: 4.0, top: 32.0, right: 4.0, bottom: 32.0),
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
            // sized box
            SizedBox(
              height: 1,
              // color
              child: Container(
                color: Colors.black,
              ),
            ),
            const Expanded(
                child: PostPage()), // add Expanded to take up remaining space
          ],
        ));
  }
}
