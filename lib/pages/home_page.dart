import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
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
            icon: const Icon(Icons.person_add, size: 35.0),
            color: const Color.fromARGB(255, 255, 255, 255),
            onPressed: () {
              // Handle the button's onPressed event
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 12), // Add a gap of 12 pixels
            Center(
              child: Container(
                height: 180,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromARGB(255, 255, 255, 255),
                padding: const EdgeInsets.all(20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 50.0,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12), // Add a gap of 12 pixels
            Center(
              child: Container(
                height: 180,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromARGB(255, 255, 255, 255),
                padding: const EdgeInsets.all(20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 50.0,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12), // Add a gap of 12 pixels
            Center(
              child: Container(
                height: 180,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromARGB(255, 255, 255, 255),
                padding: const EdgeInsets.all(20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 50.0,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12), // Add a gap of 12 pixels
          ],
        ),
      ),
    );
  }
}
