import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:monitoring_hamil/models/activity.dart';

Future<Activity> getActivityDetails() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/activity_details'));

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, then parse the JSON.
    return Activity.fromJson(jsonDecode(response.body));
  } else {
    // If the server returns an unsuccessful response code, then throw an exception.
    throw Exception('Failed to load activity details');
  }
}