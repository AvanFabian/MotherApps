import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monitoring_hamil/pages/welcome_page.dart';
import 'package:monitoring_hamil/res/constants.dart';
import 'package:monitoring_hamil/Models/api_response.dart';
import 'package:monitoring_hamil/Models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monitoring_hamil/services/activity_service.dart';
import 'package:monitoring_hamil/Models/activity.dart';

// login
Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(loginURL),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password});

    // debug
    print("Login Response user_service: ${response.body}");

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      // case 200:
      //   var responseBody = jsonDecode(response.body);
      //   if (responseBody['user'] is Map<String, dynamic>) {
      //     print('User object: ${responseBody['user']}');
      //     try {
      //       apiResponse.data = User.fromJson(responseBody['user']);
      //     } catch (e) {
      //       print('Error parsing user: $e');
      //     }
      //   } else {
      //     print('Unexpected format for user: ${responseBody['user']}');
      //   }
      //   break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        var responseBody = json.decode(response.body);
        apiResponse.error = 'somethingWentWrong: ${responseBody['message']}';
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// Register
Future<ApiResponse> register(String name, String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(registerURL), headers: {
      'Accept': 'application/json'
    }, body: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      // case 200:
      //   var responseBody = jsonDecode(response.body);
      //   apiResponse.data = User.fromJson(responseBody['user']);
      //   apiResponse.token = responseBody['token'];
      //   break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Fetch single user detail
Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(userURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    print("User Detail Response: ${response.body}");

    switch (response.statusCode) {
      case 200:
        var responseBody = jsonDecode(response.body);
        if (responseBody['user'] is Map<String, dynamic>) {
          apiResponse.data = User.fromJson(responseBody['user']);
        } else {
          print('Unexpected format for user: ${responseBody['user']}');
        }
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Fetch all users details
Future<List<User>> getUsersDetails() async {
  List<User> users = [];
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(allUsersURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var usersJson = jsonData['users']; // Access the 'users' key
      for (var userJson in usersJson) {
        User user = User.fromJson(userJson);
        if (user.id != null) {
          List<ActivityRecord> activityRecords =
              (await getActivityRecords(user.id!)).cast<ActivityRecord>();
          int totalPoints = activityRecords.fold(
              0,
              (sum, record) =>
                  sum +
                  (record.duration) +
                  (record.totalCaloriesBurned.toInt()));
          user.totalPoints = totalPoints;
        }
        users.add(user);
      }
    } else if (response.statusCode == 401) {
      throw Exception(unauthorized);
    } else {
      throw Exception(somethingWentWrong);
    }
  } catch (e) {
    print('Failed to fetch user details: $e');
    throw Exception('Failed to fetch user details');
  }
  return users;
}

// Update user
Future<ApiResponse> updateUser(String name, String email, String? image) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(Uri.parse(userURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: image != null
            ? {'name': name, 'email': email, 'image': image}
            : {'name': name, 'email': email});
    // user can update his/her name or name and image

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// get token
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// get user id
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

// logout
Future<bool> logout(BuildContext context) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool result = await pref.remove('token');
  if (result) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
      (Route<dynamic> route) => false,
    );
  }
  return result;
}

// Get base64 encoded image
String? getStringImage(File? file) {
  if (file == null) return null;
  return base64Encode(file.readAsBytesSync());
}
