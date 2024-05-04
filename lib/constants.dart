// ----- STRINGS ------
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

const grey = Color(0xFFD1D4D9);
const darkGrey = Color(0xFF212121);
const white = Colors.white;
const orange = Color(0xFFC86300);
const green = Color(0xFF27AD00);
const red = Color(0xFFD6000C);
const yellow = Color(0xFFFAB700);
const black = Color(0xFF252525);
const blue = Color(0xFF000FA5);
const backgroundGrey = Color(0xFFE1E3E5);
const blueGrey = Color(0xFF444b59);
const brown = Color(0xFFD2691E);

const patientPrimary = Color(0xFF0F7F85);
const hospitalPrimary = Color(0xFF0F7F85);
const physicianPrimary = Color(0xFF0F7F85);
const manufacturerPrimary = Color(0xFF0F7F85);


const fdaPrimary = Color(0xFFC48253);
const insurancePrimary = Color(0xFFCE8789);
const messages = Color(0xFFA09EAF);
const baseThemePrimary = Color(0xFF0F7F85);
const devicecolor = Color(0xFFD5AB5A);
const selectedGrey = Color(0xFFE2E2E2);
const formBackground = Colors.white;


const selectedMenuItem = Color(0xFF414D55);
const textBoxBackground = Colors.white;
const backGroundColor = Color(0xFF454F62);
const containerbBodyColor = Color(0xFFE5E5E5);
const sideBarGradient1 = Color(0xFFD5D5D5);
const sideBarGradient2 = Color(0xFFFFFFFF);


const sideIcon = Color(0xFF0A1F44);
const sideIconSelected = Color(0xFF16BDC7);
const header = Color(0xFF1F3C51);
const backGroundGradient1 = Color(0xFFE2E2E2);
const backGroundGradient2 = Color(0xFFF0F0F0);
const mobileBodyColor = Color(0xFF1B3C51);
const messageMenuBackgroubd = Color(0xFF262A31);
const mMenuColor = Color(0xFF1D394E);
const mColor = Color(0xFF93AE4A);
const menuBorderColor = Color(0xFF676464);
const menuActive = Color(0xFF0F7F85);
const menuDeActive = Color(0xFF1D394E);




const lightPink = Color(0xffee6cb6);
const lightPink1 = Color(0xffea76c4);
const lightPink2 = Color(0xffe680d2);
const lightPink3 = Color(0xffe08ade);
const lightPink4 = Color(0xffda94e9);
const lightPink5 = Color(0xffcd98f0);
const lightPink6 = Color(0xffbf9df5);
const lightPink7 = Color(0xffb0a1f9);
const lightPink8 = Color(0xff95a1f9);
const lightPink9 = Color(0xff76a1f7);
const lightPink10 = Color(0xff52a0f2);
const lightPink11 = Color(0xff149feb);


const lightBlue = Color(0xffB07EE8);
const darkRed = Color(0xffBC082B);


const darkGreen = Color(0xff1c2025);
const lightGreen = Color(0xff2d2f3a);
const lightOrange = Color(0xfffaa587);

const lightChocolate = Color(0xff525151);
const lightChocolate1 = Color(0xff393939);
const lightChocolate2 = Color(0xff363636);


const lightGreen2 = Color(0xff15667D);
const lightGreen3 = Color(0xff53AFC9);


const darkPink = Color(0xffff00c4);
const lightOrange2 = Color(0xfff18a5c);
const lightblue3 = Color(0xff5cc8f1);
const lightbegini3 = Color(0xff745cf1);
const lightpink3 = Color(0xffc55cf1);

const lightGrn3 = Color(0xff5cf198);
const lightyellow3 = Color(0xfff1d85c);
const lightRed3 = Color(0xfff15c5c);
const lightBack3 = Color(0xfff8f8fb);

//calculator Colors

const calculatorScreen = Color(0xff222433);
const calculatorButton = Color(0xff2C3144);
const calculatorFunctionButton = Color(0xff35364A);
const calculatorYellow = Color(0xffFEBc06);

//car booking colors

const carButtonColor = Color(0xff1e75ff);
const carLeftTopColor = Color(0xff32a9fd);
const carLeftBottomColor = Color(0xff1055e1);
const carRightTopColor = Color(0xff23233d);
const carRightBottomColor = Color(0xff08070d);


//Game Home Screen
const gameHomeRight1 = Color(0xff35abe9);
const gameHomeRight2 = Color(0xff454ce5);

const gameHomeLeft1 = Color(0xff232941);
const gameHomeLeft2 = Color(0xff171925);

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);

const double defaultPadding = 16.0;

// ----- API URLS -----
const baseURL = 'http://10.0.2.2:8000/api';
const loginURL = '$baseURL/login';
const registerURL = '$baseURL/register';
const logoutURL = '$baseURL/logout';
const userURL = '$baseURL/user';
const postsURL = '$baseURL/posts';
const commentsURL = '$baseURL/comments';

// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';

// --- input decoration
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.all(10),
      border: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black)));
}

// button

TextButton kTextButton(String label, Function onPressed) {
  return TextButton(
    child: Text(
      label,
      style: const TextStyle(color: Colors.white),
    ),
    style: ButtonStyle(
        backgroundColor:
            MaterialStateColor.resolveWith((states) => Colors.blue),
        padding: MaterialStateProperty.resolveWith(
            (states) => const EdgeInsets.symmetric(vertical: 10))),
    onPressed: () => onPressed(),
  );
}

// loginRegisterHint
Row kLoginRegisterHint(String text, String label, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
          child: Text(label, style: const TextStyle(color: Colors.blue)),
          onTap: () => onTap())
    ],
  );
}

// likes and comment btn

Expanded kLikeAndComment(
    int value, IconData icon, Color color, Function onTap) {
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
