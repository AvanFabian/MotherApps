import 'package:flutter/material.dart';
// import 'package:monitoring_hamil/pages/home_page.dart';
import 'package:monitoring_hamil/pages/layout.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Align(
              alignment: Alignment.centerRight,
              child: Text(
            'Close',
            style: TextStyle(
                fontSize: 16.0, // Adjust the size as needed
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 239, 77, 2)),
          )),
        ), // Wrap with Center
        title: const Text(
          '[Exercise Name]',
          style: TextStyle(
            fontSize: 20.0, // Adjust the size as needed
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true, // This centers the title
        backgroundColor: Colors.white70,
        elevation: 0, // z-coordinate of the app bar
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              // settings icon
              icon: const Icon(Icons.refresh, size: 30.0),
              color: Colors.black,
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('Hello World!'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: SizedBox(
          height: 60.0, // Adjust as needed
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const Layout()),
                      (route) => false);
                },
                child: const CircleAvatar(
                  radius: 28.0, // Adjust the size as needed
                  backgroundColor: Colors.white, // Adjust the color as needed
                  child: Icon(
                    Icons.home,
                    size: 28.0, // Adjust the size as needed
                    color: Colors.black, // Adjust the color as needed
                  ),
                ),
              ),
                FloatingActionButton(
                  mini: false,  
                  backgroundColor: Colors.amber,
                  onPressed: () {},
                  shape: const CircleBorder(),
                  child: const Text('Start'),
                ),
              const Icon(Icons.map, size: 28.0), // Adjust the size as needed
            ],
          ),
        ),
      ),
    );
  }
}
