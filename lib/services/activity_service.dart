import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:monitoring_hamil/models/activity.dart';

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
  var activityResponse = await http.get(
    Uri.parse(
        'http://10.0.2.2:8000/api/sports_activities?name=$selectedExercise'),
  );
  var activityData = jsonDecode(activityResponse.body);
  return activityData['id'];
}

Future<List<int>> getSportMovementIds(List<String> selectedSubMovements) async {
  List<int> sportMovementIds = [];
  for (var movement in selectedSubMovements) {
    var movementResponse = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/sports_movements?name=$movement'),
    );
    var movementData = jsonDecode(movementResponse.body);
    sportMovementIds.add(movementData['id']);
  }
  return sportMovementIds;
}

Future<http.Response> postActivityRecord(Map<String, String> body) {
  return http.post(
    Uri.parse('http://10.0.2.2:8000/api/activity_records'),
    body: body,
  );
}

Future<Map<String, dynamic>> fetchExercisesAndMovements() async {
  // Fetch exercises
  var exercisesResponse =
      await http.get(Uri.parse('http://10.0.2.2:8000/api/sports_activities'));
  var exercisesData = jsonDecode(exercisesResponse.body);
  print("Exercises data: $exercisesData");
  List<String> exercises = (exercisesData as List).map((item) => item['sport_type'] as String).toList();
  // Fetch movements for each exercise
  Map<String, List<String>> subMovements = {};
  for (var exercise in exercises) {
    var movementsResponse = await http.get(Uri.parse(
        'http://10.0.2.2:8000/api/sports_movements?activity_name=$exercise'));
    var movementsData = jsonDecode(movementsResponse.body);
    subMovements[exercise] = (movementsData as List).map((item) => item['name'] as String).toList();
  }

  return {'exercises': exercises, 'subMovements': subMovements};
}
