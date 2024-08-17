import 'dart:async';
import 'package:flutter/material.dart';
import 'package:monitoring_hamil/main.dart';
import 'package:monitoring_hamil/pages/activitydetail_page.dart';
import 'package:monitoring_hamil/pages/layout.dart';
import 'package:monitoring_hamil/services/user_service.dart';
import 'package:monitoring_hamil/services/activity_service.dart';
import 'package:monitoring_hamil/res/constants.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  int totalDuration = 0;
  bool isActivityStarted = false;

  Stream<double>? _stream;
  late Map<int, int> caloriesBurnedPredictions = {};

  @override
  void initState() {
    super.initState();
    loadExercisesAndMovements();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      TimerModel timerModel = Provider.of<TimerModel>(context, listen: false);
      selectedExercise = timerModel.selectedExercise;
      selectedSubMovements = timerModel.selectedSubMovements;
      _stream = timerModel.stream;
    });
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
    TimerModel timerModel = Provider.of<TimerModel>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                TimerModel timerModel =
                    Provider.of<TimerModel>(context, listen: false);
                if (timerModel.isActivityStarted) {
                  // Only preserve selectedExercise and selectedSubMovements if the activity is running
                  timerModel.selectedExercise = selectedExercise;
                  timerModel.selectedSubMovements = selectedSubMovements;
                }
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Layout()),
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
                MediaQuery.of(context).size.width * 0.6, // 75% of screen width
            child: TextButton(
              child: Text(
                selectedExercise ?? "Choose Activity",
                style: const TextStyle(
                  color: signatureTextColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w800,
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
                                  0.9, // Adjust this value to change the width of the modal
                              child: ListView.builder(
                                itemCount: exercises.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    title: Text(
                                      exercises[index],
                                      style: const TextStyle(
                                        color: signatureTextColor,
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
                                        selectedSubMovements = [];
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
        centerTitle: true,
        backgroundColor: signatureAppColor,
        elevation: 0, // z-coordinate of the app bar
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              // settings icon
              icon: const Icon(Icons.refresh, size: 30.0),
              color: Colors.black,
              onPressed: () {
                setState(() {
                  // This will rebuild your widget
                });
              },
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
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 24.0),
                  child: Column(
                    children: [
                      const Text(
                        'Total Time',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        formatDuration(
                          Duration(
                              seconds:
                                  totalDuration), // Use totalDuration instead of duration
                        ),
                        style: const TextStyle(
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
                        'Burned Calories :',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: signatureTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      StreamBuilder<double>(
                        stream: _stream,
                        initialData: 0.0,
                        builder: (BuildContext context,
                            AsyncSnapshot<double> snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              '${snapshot.data?.toStringAsFixed(2)} kcal', // Display the total calories burned
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
                          return const CircularProgressIndicator();
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
              child: Consumer<TimerModel>(
                builder: (context, timerModel, child) {
                  final duration = timerModel.duration;
                  return Text(
                    '${duration ~/ 3600}:${(duration % 3600) ~/ 60}:${(duration % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 50.0, // Increase the font size
                    ),
                  );
                },
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
              // sport movement icon
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
                                    padding: const EdgeInsets.only(top: 52.0),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: ListView.builder(
                                        itemCount:
                                            subMovements[selectedExercise!]!
                                                .length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          String value = subMovements[
                                              selectedExercise!]![index];
                                          return Column(
                                            children: <Widget>[
                                              _MyCheckboxListTile(
                                                value: value,
                                                isChecked: selectedSubMovements
                                                    .contains(value),
                                                onChanged: (bool? newValue) {
                                                  if (newValue == true) {
                                                    selectedSubMovements
                                                        .add(value);
                                                  } else {
                                                    selectedSubMovements
                                                        .remove(value);
                                                  }
                                                },
                                              ),
                                              FutureBuilder<String>(
                                                future:
                                                    getYoutubeUrlForMovement(
                                                        selectedExercise!,
                                                        value),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<String>
                                                        snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const SizedBox
                                                        .shrink();
                                                  } else {
                                                    print(
                                                        'snapshot.data: ${snapshot.data}');
                                                    print(
                                                        'snapshot.hasData: ${snapshot.hasData}');
                                                    String? videoId;
                                                    if (snapshot.hasData &&
                                                        snapshot.data != null &&
                                                        snapshot
                                                            .data!.isNotEmpty) {
                                                      print(
                                                          'Youtube URL: ${snapshot.data}');
                                                      videoId = YoutubePlayer
                                                          .convertUrlToId(
                                                              snapshot.data!);
                                                    }
                                                    print(
                                                        'Youtube video ID: $videoId');
                                                    return videoId != null
                                                        ? YoutubePlayer(
                                                            controller:
                                                                YoutubePlayerController(
                                                              initialVideoId:
                                                                  videoId,
                                                              flags:
                                                                  const YoutubePlayerFlags(
                                                                autoPlay: false,
                                                                mute: false,
                                                              ),
                                                            ),
                                                            showVideoProgressIndicator:
                                                                true,
                                                            progressIndicatorColor:
                                                                Colors
                                                                    .blueAccent,
                                                          )
                                                        : const SizedBox(
                                                            width: 100,
                                                            height: 75,
                                                            child: DecoratedBox(
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .grey)));
                                                  }
                                                },
                                              ),
                                            ],
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
              if (!timerModel.isActivityStarted || timerModel.isPressed)
                SizedBox(
                  height: 70.0,
                  width: 70.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0), // remove extra space
                      shape: const CircleBorder(), // set the shape to circle
                    ),
                    onPressed: () async {
                      TimerModel timerModel =
                          Provider.of<TimerModel>(context, listen: false);
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
                        timerModel
                            .toggleActivityStarted(); // Toggle the activity state only if an exercise is selected and there are sub-movements
                        // STOP BUTTON CONDITION
                        if (timerModel.isPressed) {
                          // Get the current duration before stopping the timer
                          TimerModel timerModel =
                              Provider.of<TimerModel>(context, listen: false);
                          duration = timerModel.duration;
                          totalDuration = duration; // Store the total duration
                          print('Total duration: $totalDuration');
                          timerModel
                              .stopTimer(); // Stop the timer in the TimerModel
                          // Get the user ID
                          int userId = await getUserId();
                          // Get the ID of the selected sport activity
                          int sportActivityId =
                              await getSportActivityId(selectedExercise!);
                          // Get the IDs of the selected sport movements
                          List<int> sportMovementIds =
                              await getSportMovementIds(selectedSubMovements);
                          print(
                              "Selected sub-movements: $selectedSubMovements");

                          // Calculate the total calories burned
                          double totalCaloriesBurned =
                              timerModel.totalCaloriesBurned;
                          for (int id in sportMovementIds) {
                            totalCaloriesBurned += duration *
                                (caloriesBurnedPredictions[id] ?? 0) /
                                3600;
                          }
                          // Make a POST request to store the duration and total calories burned in the database
                          var response = await postActivityRecord({
                            'user_id': userId.toString(),
                            'sport_activity_id': sportActivityId.toString(),
                            'sport_movement_ids': sportMovementIds.join(','),
                            'duration': duration.toString(),
                            'total_calories_burned':
                                totalCaloriesBurned.toStringAsFixed(2),
                          });

                          // Check the status code of the response
                          if (response.statusCode == 201) {
                            print(
                                'Duration successfully stored in the database');
                          } else {
                            print(
                                'Failed to store the duration in the database');
                            print('Response body: ${response.body}');
                          }
                          duration = 0; // Reset the duration

                          timerModel
                              .togglePressed(); // Toggle the state of the button
                        }
                        // START BUTTON CONDITION
                        else {
                          getSportMovementIds(selectedSubMovements).then((ids) {
                            getCaloriesBurnedPredictions(ids)
                                .then((predictions) async {
                              if (predictions.isNotEmpty) {
                                Provider.of<TimerModel>(context, listen: false)
                                    .caloriesBurnedPredictions = predictions;
                                Provider.of<TimerModel>(context, listen: false)
                                    .startTimer(ids); // Start the timer
                              } else {
                                print(
                                    'No calories burned predictions available');
                              }
                            }).catchError((e) {
                              print(
                                  'Failed to load calories burned predictions: $e');
                            });
                          }).catchError((e) {
                            print('Failed to load sport movement IDs: $e');
                          });

                          timerModel
                              .togglePressed(); // Toggle the state of the button
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Success'),
                              content: Text(timerModel.isPressed
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
                      }
                    },
                    child: Icon(
                      timerModel.isPressed ? Icons.stop : Icons.play_arrow,
                      size: 40.0,
                      color: Colors.black,
                    ),
                  ),
                ),

              // pause button
              if (timerModel.isActivityStarted && timerModel.isPressed)
                SizedBox(
                  height: 70.0,
                  width: 70.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      shape: const CircleBorder(),
                    ),
                    onPressed: () {
                      if (!timerModel.isActivityStarted) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Warning'),
                            content: const Text(
                                'Cannot Pause the Timer without Starting the Activity First.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        setState(() {
                          timerModel.isPaused = !timerModel
                              .isPaused; // Toggle the state of the pause button in TimerModel
                          if (timerModel.isPaused) {
                            timer?.cancel(); // Stop the timer
                            timer = null; // Set the timer to null
                          } else {
                            getSportMovementIds(selectedSubMovements)
                                .then((ids) {
                              timer
                                  ?.cancel(); // Stop the timer if it's already running
                              timer = null; // Set the timer to null
                              Provider.of<TimerModel>(context, listen: false)
                                  .startTimer(ids); // Start the timer
                            }).catchError((e) {
                              print('Failed to load sport movement IDs: $e');
                            });
                          }
                        });
                      }
                    },
                    child: Icon(
                        timerModel.isPaused ? Icons.play_arrow : Icons.pause,
                        size: 40.0,
                        color: Colors.black),
                  ),
                ),

              // history icon
              SizedBox(
                height: 70.0, // or the size that you need
                width:
                    70.0, // to make it a perfect circle, width should be equal to height
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0), // remove extra space
                    shape: const CircleBorder(), // set the shape to circle
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FutureBuilder<int>(
                          // future: getUserId(),
                          future: getUserId().then((value) {
                            // print('User ID: $value');
                            return value;
                          }),
                          builder: (BuildContext context,
                              AsyncSnapshot<int> snapshot) {
                            if (snapshot.hasData) {
                              return ActivityDetailPage(userId: snapshot.data!);
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _MyCheckboxListTile extends StatefulWidget {
  final String value;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const _MyCheckboxListTile({
    required this.value,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  _MyCheckboxListTileState createState() =>
      _MyCheckboxListTileState(isChecked: isChecked);
}

class _MyCheckboxListTileState extends State<_MyCheckboxListTile> {
  bool isChecked;

  _MyCheckboxListTileState({required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.value),
      value: isChecked,
      onChanged: (bool? newValue) {
        setState(() {
          isChecked = newValue!;
        });
        widget.onChanged(newValue);
      },
    );
  }
}
