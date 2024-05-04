import 'package:flutter/material.dart';
import 'package:monitoring_hamil/pages/home_page.dart';
import 'package:monitoring_hamil/pages/leaderboard_page.dart';
import 'package:monitoring_hamil/pages/loading.dart';
import 'package:monitoring_hamil/pages/profile_page.dart';
import 'package:monitoring_hamil/pages/route_page.dart';

void main() {
  runApp(const MyApp());
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
          '/routes': (BuildContext context) => const RoutePage(),
          '/leaderboard': (BuildContext context) => const LeaderboardPage(),
          '/profile': (BuildContext context) => const ProfilePage(),
        });
  }
}
