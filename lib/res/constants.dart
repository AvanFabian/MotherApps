// ----- STRINGS ------
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:flutter_dotenv/flutter_dotenv.dart';

const signatureAppColor = Color.fromARGB(255, 253, 232, 232);
const secondaryAppColor = Color.fromARGB(255, 66, 55, 44);
const thirdAppColor = Color.fromARGB(255, 248, 139, 139);
const signatureTextColor = Color.fromARGB(255, 53, 42, 42);
const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);

const double defaultPadding = 16.0;

// ----- API URLS -----
var baseURL = dotenv.env['BASE_URL'];
var baseURL2 = dotenv.env['BASE_URL2'];
var baseURL3 = dotenv.env['BASE_URL3'];
var prodURL = dotenv.env['PROD_URL'];
var prodURL2 = dotenv.env['PROD_URL2'];
var loginURL = '$baseURL3/login';
var registerURL = '$baseURL3/register';
var logoutURL = '$baseURL3/logout';
var userURL = '$baseURL3/user';
var allUsersURL = '$baseURL3/allUsers';
var postsURL = '$baseURL3/posts';
var commentsURL = '$baseURL3/comments';

// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';

// Maps API KEY
// const String GOOGLE_MAPS_API_KEY = "API_KEY_HERE";

// --- input decoration
InputDecoration kInputDecoration(String hint, {Color bgColor = Colors.white, Color hintColor = Colors.grey}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: hintColor), // Change the color of the hint text
    filled: true,
    fillColor: bgColor, // Change the background color
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide.none,
    ),
  );
}

// button
TextButton kTextButton(String label, Function onPressed, {Color? backgroundColor}) {
  return TextButton(
    style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) => backgroundColor ?? signatureAppColor),
        padding: WidgetStateProperty.resolveWith((states) => const EdgeInsets.symmetric(vertical: 10))),
    onPressed: () => onPressed(),
    child: Text(
      label,
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
  );
}

// button for auth pages
TextButton kTextButtonAuth(String label, Function onPressed, {Color? backgroundColor}) {
  return TextButton(
    style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) => backgroundColor ?? signatureAppColor),
        padding: WidgetStateProperty.resolveWith((states) => const EdgeInsets.symmetric(vertical: 10))),
    onPressed: () => onPressed(),
    child: Text(
      label,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}

// format duration
String formatDuration(Duration duration) {
  final twoDigitMinutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final twoDigitSeconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
}

// loginRegisterHint
Row kLoginRegisterHint(String text, String label, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [Text(text), GestureDetector(child: Text(label, style: const TextStyle(color: Colors.blue)), onTap: () => onTap())],
  );
}

// likes and comment btn

Expanded kLikeAndComment(int value, IconData icon, Color color, Function onTap) {
  return Expanded(
    child: Material(
      child: InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 4),
              Text('$value')
            ],
          ),
        ),
      ),
    ),
  );
}

void logMessage(String message, {int level = 0}) {
  const productionLogLevel = 2;
  if (level >= productionLogLevel) {
    developer.log(message, name: 'Message');
  }
}
