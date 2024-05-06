// setup
import 'package:flutter/material.dart';
import 'package:monitoring_hamil/res/constants.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  // simple widget text hello world
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Center(
            child: Text(
          'Close',
          style: TextStyle(
              fontSize: 16.0, // Adjust the size as needed
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 239, 77, 2)),
        )), // Wrap with Center
        title: const Text(
          'Exercise Name',
          style: TextStyle(
            fontSize: 20.0, // Adjust the size as needed
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true, // This centers the title
        backgroundColor: Colors.white70,
        elevation: 0, // z-coordinate of the app bar
        actions: <Widget>[
          IconButton(
            // settings icon
            icon: const Icon(Icons.refresh, size: 30.0),
            color: Colors.black,
            onPressed: () {
              // Handle the button's onPressed event
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Hello World!'),
      ),
      bottomNavigationBar: Container(
        height: 60.0, // Adjust as needed
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(Icons.home, size: 28.0), // Adjust the size as needed
            FloatingActionButton(
              onPressed: () {
                // Add your onPressed code here
              },
              child: Text('Start'),
            ),
            Icon(Icons.map, size: 28.0), // Adjust the size as needed
          ],
        ),
      ),
    );
  }
}
