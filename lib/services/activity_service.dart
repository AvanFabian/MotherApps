import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:monitoring_hamil/models/activity.dart';
import 'package:monitoring_hamil/services/user_service.dart';
import 'package:monitoring_hamil/res/constants.dart';

Future<List<ActivityRecord>> getActivityRecords(int userId) async {
  String token = await getToken();
  final response = await http.get(
    Uri.parse('$baseURL3/activity_records/user/$userId'),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, then parse the JSON.
    List<dynamic> body = jsonDecode(response.body);
    // status code
    print('Status Code: ${response.statusCode}');
    print('Server Response: $body');
    return body.map((dynamic item) => ActivityRecord.fromJson(item)).toList();
  } else {
    // If the server returns an unsuccessful response code, then throw an exception.
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    throw Exception('Failed to load activity records');
  }
}

Future<int> getSportActivityId(String selectedExercise) async {
  String token = await getToken();
  var activityResponse = await http.get(
    Uri.parse('$baseURL3/sports_activity_id?activity_name=$selectedExercise'),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );
  if (activityResponse.statusCode == 200) {
    var activityId = jsonDecode(activityResponse.body);
    print('Activity ID: $activityId');
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
      Uri.parse('$baseURL3/sports_movement_id?activity_name=$movement'),
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

// mendapatkan data kalori terbakar untuk setiap gerakan olahraga dari database
Future<Map<int, int>> getCaloriesBurnedPredictions(List<int> ids) async {
  print('IDs: ${ids.join(',')}');
  String token = await getToken();
  var response = await http.get(
    Uri.parse('$baseURL3/sports_movements/calories?ids=${ids.join(',')}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON.
    Map<int, int> predictions = (jsonDecode(response.body) as Map).map((key, value) => MapEntry(int.parse(key), value));
    return predictions;
  } else {
    // If the server returns an unexpected response, throw an exception.
    throw Exception('Failed to load calories burned predictions');
  }

  // if (response.statusCode == 200) {
  //   // If the server returns a 200 OK response, parse the JSON.
  //   return (jsonDecode(response.body) as List)
  //       .map((item) => item as int)
  //       .toList();
  // } else {
  //   // If the server returns an unexpected response, throw an exception.
  //   throw Exception('Failed to load calories burned predictions');
  // }
}

Future<http.Response> postActivityRecord(Map<String, String> body) async {
  String token = await getToken();
  return http.post(
    Uri.parse('$baseURL3/activity_records'),
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
    Uri.parse('$baseURL3/sports_activities'),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );

  var exercisesData = jsonDecode(exercisesResponse.body);
  // print("Exercises data: $exercisesData");

  List<String> exercises = (exercisesData as List).map((item) => item['sport_type'] as String).toList();

  Map<String, List<String>> subMovements = {};

  for (var exercise in exercises) {
    var movementsResponse = await http.get(
      Uri.parse('$baseURL3/sports_movements?activity_name=$exercise'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    // print("Movements response: ${movementsResponse.body}");

    var movementsData = jsonDecode(movementsResponse.body);
    subMovements[exercise] = (movementsData as List).map((item) => item['name'] as String).toList();
  }

  return {'exercises': exercises, 'subMovements': subMovements};
}

Future<String> getYoutubeUrlForMovement(String exerciseName, String movementName) async {
  String token = await getToken();
  print('Exercise name: $exerciseName');
  final response = await http.get(
    Uri.parse('$baseURL3/sports_movements?activity_name=$exerciseName'),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );

  print('Response status code: ${response.statusCode}');
  if (response.statusCode == 200) {
    List<dynamic> sportsMovements = jsonDecode(response.body);
    for (var movement in sportsMovements) {
      // print('Movement: $movement');
      if (movement['name'] == movementName) {
        // print('Youtube link: ${movement['youtube_link']}');
        return movement['youtube_link'] ?? '';
      }
    }
  } else {
    throw Exception('Failed to load sports movements');
  }

  return ''; // return an empty string if the youtube link is not found
}
