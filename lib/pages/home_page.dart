import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[200],
      appBar: AppBar(
        title: const Center(child: Text('Galeri Catatan')),
        backgroundColor: Colors.deepOrange[400],
        elevation: 0, // z-coordinate of the app bar
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        // logout button
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {},
          ),
        ],
      ),
      body: GridView.builder(
        itemCount: 6, // Number of items
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
        ),
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.redAccent[200],
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  Text(
                    'Hello World',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center, // Centers text horizontally
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
