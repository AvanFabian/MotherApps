// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monitoring_hamil/pages/home_page.dart';
import 'package:monitoring_hamil/pages/leaderboard_page.dart';
import 'package:monitoring_hamil/pages/route_page.dart';
import 'package:monitoring_hamil/pages/loading.dart';
import 'package:monitoring_hamil/pages/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create an instance of TimerModel
  TimerModel timerModel = TimerModel();
  await dotenv.load(fileName: ".env");

  // Retrieve the saved time timer value
  await timerModel.retrieveTimeAndTimerValue();

  runApp(
    ChangeNotifierProvider.value(
      value: timerModel,
      child: const MyApp(),
    ),
  );

  // Add the observer
  WidgetsBinding.instance.addObserver(timerModel);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: const Loading(), routes: <String, WidgetBuilder>{
      '/home': (BuildContext context) => const HomePage(),
      '/loading': (BuildContext context) => const Loading(),
      '/routes': (BuildContext context) => const RoutePage(),
      '/leaderboard': (BuildContext context) => const LeaderboardPage(),
      '/profile': (BuildContext context) => const ProfilePage(),
    });
  }
}

class TimerModel with ChangeNotifier, WidgetsBindingObserver {
  int duration = 0;
  int totalDuration = 0;
  double totalCaloriesBurned = 0.0; // Add this line
  Timer? timer;
  bool _isPressed = false;
  bool _isPaused = false;
  bool _isActivityStarted = false;

  String? selectedExercise;
  List<String> selectedSubMovements = [];

  int sportActivityId = 0; // Add this line

  int _elapsedTime = 0;

  int get elapsedTime => _elapsedTime;
  set elapsedTime(int value) {
    _elapsedTime = value;
    notifyListeners();
  }

  bool get isActivityStarted => _isActivityStarted;
  set isActivityStarted(bool value) {
    _isActivityStarted = value;
    notifyListeners();
  }

  bool get isPressed => _isPressed;
  set isPressed(bool value) {
    _isPressed = value;
    notifyListeners();
  }

  bool get isPaused => _isPaused;
  late Map<int, int> caloriesBurnedPredictions = {};
  final StreamController<double> _streamController = StreamController<double>.broadcast();
  late Stream<double> _stream;

  Stream<double> get stream => _stream;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // The app is being closed
      // Save the ids list and the activity id to SharedPreferences
      saveIds(selectedSubMovements.map(int.parse).toList());
      saveActivityId(sportActivityId);
      saveTotalCaloriesBurned(totalCaloriesBurned);
      saveCaloriesBurnedPredictions(caloriesBurnedPredictions);
    } else if (state == AppLifecycleState.resumed) {
      // The app is reopened
      // Retrieve the ids list and the activity id from SharedPreferences and restart the timer
      retrieveIds().then((ids) {
        print('Retrieved ids: $ids');
        if (ids != null) {
          startTimer(ids);
        }
      });
      retrieveActivityId().then((activityId) {
        print('Retrieved activity id: $activityId');
        if (activityId != null) {
          sportActivityId = activityId;
        }
      });
      // CALORIES BURNED PREDICTIONS SAVING LOGIC
      retrieveTotalCaloriesBurned().then((totalCalories) {
        print('Retrieved total calories: $totalCalories');
        if (totalCalories != null) {
          totalCaloriesBurned = totalCalories;
          _streamController.add(totalCaloriesBurned);
        }
      });
      retrieveCaloriesBurnedPredictions().then((predictions) {
        print('Retrieved calories burned predictions: $predictions');
        if (predictions != null) {
          caloriesBurnedPredictions = predictions;
        }
      });
    }
  }

  TimerModel() {
    _stream = _streamController.stream;
    _stream.listen((totalCaloriesBurned) {
      print('Total calories burned in main: $totalCaloriesBurned');
    });
  }
  void addToStream(double value) {
    _streamController.add(value);
  }

  Future<void> saveActivityId(int activityId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('activityId', activityId);
  }

  Future<int?> retrieveActivityId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('activityId');
  }

  // CALORIES BURNED PREDICTIONS SAVING LOGIC
  Future<void> saveTotalCaloriesBurned(double totalCalories) async {
    // print('Saving total calories burned: $totalCalories');
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('totalCaloriesBurned', totalCalories);
  }

  Future<double?> retrieveTotalCaloriesBurned() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('totalCaloriesBurned');
  }

  Future<void> saveCaloriesBurnedPredictions(Map<int, int> predictions) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, int> stringKeyPredictions = predictions.map((key, value) => MapEntry(key.toString(), value));
    prefs.setString('caloriesBurnedPredictions', jsonEncode(stringKeyPredictions));
  }

  Future<Map<int, int>?> retrieveCaloriesBurnedPredictions() async {
    final prefs = await SharedPreferences.getInstance();
    String? predictionsJson = prefs.getString('caloriesBurnedPredictions');
    if (predictionsJson != null) {
      Map<String, int> stringKeyPredictions = Map<String, int>.from(jsonDecode(predictionsJson));
      return stringKeyPredictions.map((key, value) => MapEntry(int.parse(key), value));
    } else {
      return null;
    }
  }

  // TIMER SAVING LOGIC
  Future<void> saveTimeAndTimerValue(bool isStarting) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('savedTime', DateTime.now().millisecondsSinceEpoch);
    if (isStarting) {
      prefs.setInt('savedTimerValue', duration);
    } else {
      prefs.setInt('savedTimerValue', totalDuration);
    }

    print('Saved time: ${DateTime.now().millisecondsSinceEpoch}');
    print('Saved timer value: ${isStarting ? duration : totalDuration}');
  }

  Future<void> retrieveTimeAndTimerValue() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTimeMillis = prefs.getInt('savedTime');
    final savedTimerValue = prefs.getInt('savedTimerValue');
    final wasActivityStarted = prefs.getBool('isActivityStarted') ?? false;

    if (savedTimeMillis != null && savedTimerValue != null && wasActivityStarted) {
      DateTime savedTime = DateTime.fromMillisecondsSinceEpoch(savedTimeMillis);
      DateTime now = DateTime.now();
      Duration elapsedTime = now.difference(savedTime);
      int newTimerValue = savedTimerValue + elapsedTime.inSeconds;

      print('Saved time: $savedTime');
      print('Saved timer value: $savedTimerValue');
      print('Current time: $now');
      print('Elapsed time: ${elapsedTime.inSeconds} seconds');
      print('New timer value: $newTimerValue');

      // Update the timer value
      duration = newTimerValue;
    } else if (savedTimerValue != null) {
      // If the timer was not running when the app was closed, just reset the duration to 0
      duration = 0;
    }
  }

  Future<void> saveIds(List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('savedIds', jsonEncode(ids));
  }

  Future<List<int>?> retrieveIds() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getString('savedIds');

    if (savedIds != null) {
      return List<int>.from(jsonDecode(savedIds).map((x) => x));
    } else {
      return null;
    }
  }

  void toggleActivityStarted() {
    _isActivityStarted = !_isActivityStarted;
    notifyListeners();
  }

  void startTimer(List<int> ids) {
    // Save the ids list to SharedPreferences
    saveIds(ids);
    saveActivityId(sportActivityId);
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (!isPaused) {
        // Calculate the total calories burned
        totalCaloriesBurned = 0.0;
        double caloriesBurnedPerSecond = 0.0;

        for (int i = 0; i < ids.length; i++) {
          totalCaloriesBurned += caloriesBurnedPredictions[ids[i]] ?? 0;
        }

        // Calculate the calories burned per second
        caloriesBurnedPerSecond = totalCaloriesBurned / 3600;
        // Increase the total calories burned every second
        totalCaloriesBurned = caloriesBurnedPerSecond * duration;
        // Add the total calories burned to the stream
        _streamController.add(totalCaloriesBurned);
        // Increase the duration
        duration++;
        notifyListeners();
        // Save the totalCaloriesBurned and caloriesBurnedPredictions to SharedPreferences
        saveTotalCaloriesBurned(totalCaloriesBurned);
        saveCaloriesBurnedPredictions(caloriesBurnedPredictions);
        // Debugging print statements
        print('Total Calories Burned: $totalCaloriesBurned');
        print('Duration: $duration');
        print('Calories Burned Predictions: $caloriesBurnedPredictions');
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
    totalDuration = duration;
    duration = 0;
    // Reset selectedExercise, selectedSubMovements, and sportActivityId
    selectedExercise = null;
    selectedSubMovements = [];
    sportActivityId = 0;
    notifyListeners();
  }

  Future<void> togglePressed() async {
    _isPressed = !_isPressed;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPressed', isPressed);
    notifyListeners();
  }

  Future<void> togglePaused() async {
    _isPaused = !_isPaused;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPaused', isPaused);
    notifyListeners();
  }

  set isPaused(bool value) {
    _isPaused = value;
    notifyListeners(); // Notify listeners when isPaused changes
  }

  @override
  void dispose() {
    _streamController.close();
    timer?.cancel();
    super.dispose();
  }
}
