import 'dart:async';
import 'package:flutter/material.dart';
import 'package:monitoring_hamil/pages/layout.dart';
import 'package:monitoring_hamil/services/user_service.dart';
import 'package:monitoring_hamil/services/activity_service.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  List<String> exercises = [];
  Map<String, List<String>> subMovements = {};

  String? selectedExercise;
  List<String> selectedSubMovements = [];
  List<int> sportMovementIds = [];
  bool isPressed = false;
  Timer? timer;
  int duration = 0;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    loadExercisesAndMovements();
  }

  void togglePause() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  void loadExercisesAndMovements() async {
    var data = await fetchExercisesAndMovements();
    setState(() {
      exercises = data['exercises'];
      subMovements = data['subMovements'];
    });
  }

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
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 24.0),
                    child: Column(
                      children: [
                        Text(
                          'Total Time',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '00:00:00',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16.0, top: 24.0),
                    child: Column(
                      children: [
                        Text(
                          'Burned Calories:',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Center(
                // Center the text
                child: Text(
                  '${duration ~/ 3600}:${(duration % 3600) ~/ 60}:${(duration % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 50.0, // Increase the font size
                  ),
                ),
              ),
            ),
          ),
        ],
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
                                              color: Color.fromARGB(
                                                  255, 239, 77, 2),
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
              // start/stop button
              ElevatedButton(
                onPressed: () async {
                  if (selectedExercise == null ||
                      selectedSubMovements.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Warning'),
                          content: const Text(
                              'Please choose an activity and their sub-movement first.'),
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
                    if (isPressed) {
                      timer?.cancel(); // Stop the timer
                      // Get the user ID
                      int userId = await getUserId();
                      // Get the ID of the selected sport activity
                      int sportActivityId =
                          await getSportActivityId(selectedExercise!);
                      // Get the IDs of the selected sport movements
                      List<int> sportMovementIds =
                          await getSportMovementIds(selectedSubMovements);
                      // Make a POST request to store the duration in the database
                      var response = await postActivityRecord({
                        'user_id': userId.toString(),
                        'sport_activity_id': sportActivityId.toString(),
                        'sport_movement_ids': sportMovementIds.join(','),
                        'duration': duration.toString(),
                        // 'calories_prediction': caloriesPrediction.toString(), // TODO: sementara dibikin nullable di database-nya!
                      });
                      // Check the status code of the response
                      if (response.statusCode == 201) {
                        print('Duration successfully stored in the database');
                      } else {
                        print('Failed to store the duration in the database');
                        print('Response body: ${response.body}');
                      }
                      duration = 0; // Reset the duration
                    } else {
                      if (!isPaused) {
                        // Only start the timer when isPaused is false
                        timer =
                            Timer.periodic(const Duration(seconds: 1), (timer) {
                          setState(() {
                            duration++; // Increase the duration every second
                          });
                        });
                      }
                    }
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Success'),
                          content: Text(isPressed
                              ? 'Activity Started!'
                              : 'Activity Stopped!'),
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
                    setState(() {
                      isPressed = !isPressed; // Toggle the state of the button
                    });
                  }
                },
                child:
                    Icon(isPressed ? Icons.stop : Icons.play_arrow, size: 40.0),
              ),
              // pause button
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isPaused =
                        !isPaused; // Toggle the state of the pause button
                    if (isPaused) {
                      timer?.cancel(); // Stop the timer
                    } else {
                      timer =
                          Timer.periodic(const Duration(seconds: 1), (timer) {
                        setState(() {
                          duration++; // Increase the duration every second
                        });
                      });
                    }
                  });
                },
                child: const Icon(Icons.pause, size: 40.0),
              ),
              // clock icon
              // const Icon(Icons.access_time, size: 40.0),
            ],
          ),
        ),
      ),
    );
  }
}
