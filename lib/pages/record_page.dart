import 'dart:async';
import 'package:flutter/material.dart';
import 'package:monitoring_hamil/pages/activitydetail_page.dart';
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

  late StreamController<int> _streamController;
  late Stream<int> _stream;
  late Map<int, int> caloriesBurnedPredictions = {};
  // late List<int> caloriesBurnedPredictions = [];

  @override
  @override
  void initState() {
    super.initState();
    loadExercisesAndMovements();

    _streamController =
        StreamController<int>.broadcast(); // Use a broadcast stream
    _stream = _streamController.stream;

    // Add the listener here
    _stream.listen((totalCaloriesBurned) {
      print('Total calories burned: $totalCaloriesBurned');
    });
  }

  @override
  void dispose() {
    _streamController.close();
    timer?.cancel();
    super.dispose();
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
          padding: const EdgeInsets.only(left: 8.0),
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
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Padding(
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
                  padding: const EdgeInsets.only(right: 16.0, top: 24.0),
                  child: Column(
                    children: [
                      const Text(
                        'Burned Calories',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      StreamBuilder<int>(
                        stream: _stream,
                        initialData: 0,
                        builder: (BuildContext context,
                            AsyncSnapshot<int> snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              '${snapshot.data} kcal', // Display the total calories burned
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          }
                          // By default, show a loading spinner.
                          return CircularProgressIndicator();
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
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
                              'Please choose an Activity and the Movement First.'),
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
                      print("Selected sub-movements: $selectedSubMovements");

                      // Calculate the total calories burned
                      int totalCaloriesBurned = 0;
                      for (int i = 0; i < selectedSubMovements.length; i++) {
                        totalCaloriesBurned += (duration *
                                (caloriesBurnedPredictions[i] ?? 0) /
                                3600)
                            .round();
                        // totalCaloriesBurned +=
                        //     (duration * caloriesBurnedPredictions[i] / 3600)
                        //         .round();
                      }
                      // Make a POST request to store the duration and total calories burned in the database
                      var response = await postActivityRecord({
                        'user_id': userId.toString(),
                        'sport_activity_id': sportActivityId.toString(),
                        'sport_movement_ids': sportMovementIds.join(','),
                        'duration': duration.toString(),
                        'total_calories_burned': totalCaloriesBurned.toString(),
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
                      // Fetch the IDs of the selected sub movements
                      getSportMovementIds(selectedSubMovements).then((ids) {
                        // Fetch the calories burned predictions and start the timer when the start button is pressed
                        getCaloriesBurnedPredictions(ids).then((predictions) {
                          caloriesBurnedPredictions = predictions;

                          if (caloriesBurnedPredictions.isNotEmpty) {
                            timer = Timer.periodic(const Duration(seconds: 1),
                                (Timer t) {
                              if (!isPaused) {
                                print('isPaused: $isPaused');
                                print('ids: $ids');
                                print(
                                    'caloriesBurnedPredictions: $caloriesBurnedPredictions');
                                print('duration: $duration');
                                // Calculate the total calories burned
                                double totalCaloriesBurned = 0;
                                double caloriesBurnedPerSecond = 0;

                                for (int i = 0; i < ids.length; i++) {
                                  // Use the id to access the corresponding prediction
                                  totalCaloriesBurned +=
                                      caloriesBurnedPredictions[ids[i]] ?? 0;
                                  // totalCaloriesBurned +=
                                  //     caloriesBurnedPredictions[ids[i]];
                                }

                                // for (int i = 0; i < ids.length; i++) {
                                //   // Subtract 1 from the id to get the correct index
                                //   int index = ids[i] - 1;
                                //   totalCaloriesBurned +=
                                //       caloriesBurnedPredictions[index];
                                // }

// Calculate the calories burned per second
                                caloriesBurnedPerSecond =
                                    totalCaloriesBurned / 3600;

// Increase the total calories burned every second
                                totalCaloriesBurned =
                                    caloriesBurnedPerSecond * duration;

// Add the total calories burned to the stream
                                _streamController
                                    .add(totalCaloriesBurned.round());

// Increase the duration
                                setState(() {
                                  duration++;
                                });
                              }
                            });
                          } else {
                            print('No calories burned predictions available');
                          }
                        }).catchError((e) {
                          print(
                              'Failed to load calories burned predictions: $e');
                        });
                      }).catchError((e) {
                        print('Failed to load sport movement IDs: $e');
                      });
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
              // history icon
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FutureBuilder<int>(
                        future: getUserId(),
                        builder: (BuildContext context,
                            AsyncSnapshot<int> snapshot) {
                          if (snapshot.hasData) {
                            return ActivityDetailPage(userId: snapshot.data!);
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          // By default, show a loading spinner.
                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                  );
                },
                child: const Icon(
                  Icons.history,
                  size: 40.0,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
