import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:monitoring_hamil/models/activity.dart';
import 'package:monitoring_hamil/services/user_service.dart';

Future<Activity> getActivityDetails() async {
  final response = await http.get(Uri.parse(
      'http://10.0.2.2:8000/api/activity_details')); //TODO: Update the URL (still wrong yet)

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, then parse the JSON.
    return Activity.fromJson(jsonDecode(response.body));
  } else {
    // If the server returns an unsuccessful response code, then throw an exception.
    throw Exception('Failed to load activity details');
  }
}

Future<int> getSportActivityId(String selectedExercise) async {
  String token = await getToken();
  var activityResponse = await http.get(
    Uri.parse(
        'http://10.0.2.2:8000/api/sports_activity_id?activity_name=$selectedExercise'),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );
  if (activityResponse.statusCode == 200) {
    var activityId = jsonDecode(activityResponse.body);
    return activityId;
  } else {
    print('Request failed with status: ${activityResponse.statusCode}.');
    if (activityResponse.statusCode == 404) {
      print('No activity found with the name $selectedExercise');
    }
    throw Exception('Failed to get activity ID');
  }
}

Future<List<int>> getSportMovementIds(List<String> selectedSubMovements) async {
  String token = await getToken();
  List<int> ids = [];
  for (var movement in selectedSubMovements) {
    var response = await http.get(
      Uri.parse(
          'http://10.0.2.2:8000/api/sports_movement_id?activity_name=$movement'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var id = jsonDecode(response.body);
      ids.add(id);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      if (response.statusCode == 404) {
        print('No movement found with the name $movement');
      }
    }
  }
  return ids;
}

Future<http.Response> postActivityRecord(Map<String, String> body) async {
  String token = await getToken();
  return http.post(
    Uri.parse('http://10.0.2.2:8000/api/activity_records'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(body),
  );
}

Future<Map<String, dynamic>> fetchExercisesAndMovements() async {
  String token = await getToken();
  // Fetch exercises
  var exercisesResponse = await http.get(
    Uri.parse('http://10.0.2.2:8000/api/sports_activities'),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );
  var exercisesData = jsonDecode(exercisesResponse.body);
  print("Exercises data: $exercisesData");
  List<String> exercises = (exercisesData as List)
      .map((item) => item['sport_type'] as String)
      .toList();
  // Fetch movements for each exercise
  Map<String, List<String>> subMovements = {};
  for (var exercise in exercises) {
    var movementsResponse = await http.get(
      Uri.parse(
          'http://10.0.2.2:8000/api/sports_movements?activity_name=$exercise'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    var movementsData = jsonDecode(movementsResponse.body);
    subMovements[exercise] =
        (movementsData as List).map((item) => item['name'] as String).toList();
  }

  return {'exercises': exercises, 'subMovements': subMovements};
}
