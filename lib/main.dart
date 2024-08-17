import 'dart:async';

import 'package:flutter/material.dart';
import 'package:monitoring_hamil/pages/home_page.dart';
import 'package:monitoring_hamil/pages/leaderboard_page.dart';
import 'package:monitoring_hamil/pages/loading.dart';
import 'package:monitoring_hamil/pages/profile_page.dart';
import 'package:monitoring_hamil/pages/route_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create an instance of TimerModel
  TimerModel timerModel = TimerModel();
  await dotenv.load(fileName: ".env");
  await AndroidAlarmManager.initialize();

  // Retrieve the saved time and timer value
  await timerModel.retrieveTimeAndTimerValue();
  runApp(
    ChangeNotifierProvider.value(
      value: timerModel,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Loading(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => const HomePage(),
          '/loading': (BuildContext context) => const Loading(),
          // '/routes': (BuildContext context) => const RoutePage(),
          '/leaderboard': (BuildContext context) => const LeaderboardPage(),
          '/profile': (BuildContext context) => const ProfilePage(),
        });
  }
}

class TimerModel extends ChangeNotifier {
  int duration = 0;
  int totalDuration = 0;
  double totalCaloriesBurned = 0.0; // Add this line
  Timer? timer;
  bool _isPressed = false;
  bool _isPaused = false;
  bool _isActivityStarted = false;

  String? selectedExercise;
  List<String> selectedSubMovements = [];

  bool get isActivityStarted => _isActivityStarted;

  bool get isPressed => _isPressed;
  bool get isPaused => _isPaused;
  late Map<int, int> caloriesBurnedPredictions = {};
  final StreamController<double> _streamController =
      StreamController<double>.broadcast();
  late Stream<double> _stream;

  Stream<double> get stream => _stream;

  TimerModel() {
    _stream = _streamController.stream;
    _stream.listen((totalCaloriesBurned) {
      print('Total calories burned in main: $totalCaloriesBurned');
    });
  }

  // Add the new functions here
  Future<void> saveTimeAndTimerValue() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('savedTime', DateTime.now().millisecondsSinceEpoch);
    prefs.setInt('savedTimerValue', duration);

    print('Saved time: ${DateTime.now().millisecondsSinceEpoch}');
    print('Saved timer value: $duration');
  }

  Future<void> calculateElapsedTime() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('backgroundTime', DateTime.now().millisecondsSinceEpoch);

    print('Background time: ${DateTime.now().millisecondsSinceEpoch}');
  }

  Future<void> retrieveTimeAndTimerValue() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTime = prefs.getInt('savedTime');
    final savedTimerValue = prefs.getInt('savedTimerValue');
    final backgroundTime = prefs.getInt('backgroundTime');

    if (savedTime != null &&
        savedTimerValue != null &&
        backgroundTime != null) {
      final elapsedTime = backgroundTime - savedTime;
      final newTimerValue = savedTimerValue + elapsedTime;

      print('Saved time: $savedTime');
      print('Saved timer value: $savedTimerValue');
      print('Background time: $backgroundTime');
      print('Elapsed time: $elapsedTime');
      print('New timer value: $newTimerValue');

      // Update the timer value
      duration = newTimerValue;
    }
  }

  void toggleActivityStarted() {
    _isActivityStarted = !_isActivityStarted;
    notifyListeners();
  }

  void startTimer(List<int> ids) {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
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
    // Reset selectedExercise and selectedSubMovements
    selectedExercise = null;
    selectedSubMovements = [];
    notifyListeners();
  }

  void togglePressed() {
    _isPressed = !_isPressed;
    notifyListeners();
  }

  void togglePaused() {
    _isPaused = !_isPaused;
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
