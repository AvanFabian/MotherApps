import 'package:monitoring_hamil/pages/post_page.dart';
// import 'package:monitoring_hamil/components/profile.dart';
// import 'package:monitoring_hamil/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:monitoring_hamil/res/constants.dart';
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
          title: const Center(
            child: Text(
              'Home',
              style: TextStyle(
                fontSize: 22.0, // Adjust the size as needed
                fontWeight: FontWeight.bold,
              ),
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
              padding: const EdgeInsets.only(
                  left: 2.0, top: 0.0, right: 2.0, bottom: 0.0),
              child: Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(
                      left: 16.0, top: 16.0, right: 16.0, bottom: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8, // Take 80% of the width
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Your Weekly Snapshot',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'See More',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                                height:
                                    22.0), // Adjust the height as needed to add a vertical gap
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      right:
                                          10.0), // Adjust the padding as needed
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Activity',
                                        style: TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              10.0), // Adjust the height as needed to add a vertical gap
                                      Text(
                                        '0',
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ), // Adjust the font size as needed
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          10.0), // Adjust the padding as needed
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Time',
                                        style: TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              10.0), // Adjust the height as needed to add a vertical gap
                                      Text(
                                        '0H 0M',
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ), // Adju
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          10.0), // Adjust the padding as needed
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('Distance',
                                          style: TextStyle(
                                            color: Colors.black54,
                                          )),
                                      SizedBox(
                                          height:
                                              10.0), // Adjust the height as needed to add a vertical gap
                                      Text(
                                        '0.00 km',
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ), // Adjust the font size as needed
                                        //
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Expanded(
                child: PostPage()), // add Expanded to take up remaining space
          ],
        ));
  }
}
