import 'package:flutter/material.dart';
import 'package:monitoring_hamil/pages/home_page.dart';
// import 'package:monitoring_hamil/pages/home_page.dart';
import 'package:monitoring_hamil/pages/layout.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  List<String> exercises = ['Yoga', 'Bersih-Berish Rumah', 'Lompat Tali'];

  Map<String, List<String>> subMovements = {
    'Yoga': ['Movement 1', 'Movement 2', 'Movement 3'],
    'Bersih-Berish Rumah': ['Movement 1', 'Movement 2', 'Movement 3'],
    'Lompat Tali': ['Movement 1', 'Movement 2', 'Movement 3'],
  };

  String? selectedExercise;

  List<String> selectedSubMovements = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) =>
                          const Layout()), // Replace HomePage() with your actual homepage widget
                  (route) => false,
                );
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  fontSize: 16.0, // Adjust the size as needed
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 239, 77, 2),
                ),
              ),
            ),
          ),
        ),
        title: Theme(
          data: Theme.of(context).copyWith(
            canvasColor:
                Colors.white.withOpacity(0.8), // Adjust transparency here
          ),
          child: SizedBox(
            width:
                MediaQuery.of(context).size.width * 0.45, // 75% of screen width
            child: TextButton(
              child: Text(
                selectedExercise ?? "Choose Activity",
                style: const TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 52.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height /
                                  2, // Adjust this value to change the height of the modal
                              width: MediaQuery.of(context).size.width *
                                  0.8, // Adjust this value to change the width of the modal
                              child: ListView.builder(
                                itemCount: exercises.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    title: Text(
                                      exercises[index],
                                      style: const TextStyle(
                                        color: Colors
                                            .deepPurple, // Change the color
                                        fontSize: 20.0, // Change the font size
                                        fontWeight: FontWeight
                                            .w500, // Change the font weight
                                      ),
                                      textAlign: TextAlign
                                          .center, // Align the text to the center
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedExercise = exercises[index];
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: TextButton(
                              child: const Padding(
                                padding: EdgeInsets.only(right: 16.0),
                                child: Text(
                                  'Close',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 239, 77, 2),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
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
              TextButton(
                child: const Icon(Icons.accessibility_new_sharp,
                    size: 40.0, color: Colors.black),
                onPressed: () {
                  if (selectedExercise == null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Warning'),
                          content:
                              const Text('Please choose an activity first.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Dialog(
                              child: Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top:
                                            52.0), // Adjust this value to change the vertical gap
                                    child: SizedBox(
                                      height: MediaQuery.of(context)
                                              .size
                                              .height /
                                          2, // Adjust this value to change the height of the modal
                                      width: MediaQuery.of(context).size.width *
                                          0.8, // Adjust this value to change the width of the modal
                                      child: ListView.builder(
                                        itemCount:
                                            subMovements[selectedExercise!]!
                                                .length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          String value = subMovements[
                                              selectedExercise!]![index];
                                          return CheckboxListTile(
                                            title: Text(value),
                                            value: selectedSubMovements
                                                .contains(value),
                                            onChanged: (bool? newValue) {
                                              setState(() {
                                                if (newValue == true) {
                                                  selectedSubMovements
                                                      .add(value);
                                                } else {
                                                  selectedSubMovements
                                                      .remove(value);
                                                }
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: TextButton(
                                      child: const Padding(
                                        padding: EdgeInsets.only(right: 16.0),
                                        child: Text(
                                          'Close',
                                          style: TextStyle(
                                              color: Color.fromARGB(255, 239, 77, 2),
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
              FloatingActionButton(
                mini: false,
                backgroundColor: Colors.amber,
                onPressed: () {},
                shape: const CircleBorder(),
                child: const Text('Start'),
              ),
              const Icon(Icons.map, size: 40.0),
            ],
          ),
        ),
      ),
    );
  }
}
