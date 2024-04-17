import 'package:flutter/material.dart';
// import home_page.dart
import 'package:monitoring_hamil/pages/page_control.dart';
import 'package:monitoring_hamil/pages/home_page.dart';
import 'package:monitoring_hamil/pages/leaderboard_page.dart';
import 'package:monitoring_hamil/pages/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PageControl(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => const HomePage(),
          '/leaderboard': (BuildContext context) => const LeaderboardPage(),
          '/profile': (BuildContext context) => const ProfilePage(),
        });
  }
}
