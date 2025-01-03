import 'package:flutter/material.dart';

import '../../res/constants.dart';
import 'login_page.dart';
import 'register_page.dart';

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const LoginPage();
                },
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: thirdAppColor,
            elevation: 0,
          ),
          child: Text(
            "Login".toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const RegisterPage();
                },
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: thirdAppColor,
            elevation: 0,
          ),
          child: Text(
            "Sign Up".toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
