import 'package:monitoring_hamil/Components/Auth/login_page.dart';
import 'package:monitoring_hamil/Models/api_response.dart';
import 'package:monitoring_hamil/Models/user.dart';
// import 'package:monitoring_hamil/pages/home.dart';
import 'package:monitoring_hamil/pages/layout.dart';
// import 'package:monitoring_hamil/pages/profile_page.dart';
import 'package:monitoring_hamil/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../res/constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // _RegisterPageState createState() => _RegisterPageState();
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController nameController = TextEditingController(),
      emailController = TextEditingController(),
      passwordController = TextEditingController(),
      passwordConfirmController = TextEditingController();

  Future<void> _registerUser() async {
    setState(() {
      loading = true; // Set loading to true before the network request
    });
    ApiResponse response = await register(
        nameController.text, emailController.text, passwordController.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response.error}')));
      }
    }
    setState(() {
      loading = true; // Set loading to true before the network request
    });
  }

  // Save and redirect to home
  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const Layout(
                    initialPage: 4,
                  )),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          children: [
            TextFormField(
              controller: nameController,
              validator: (val) => val!.isEmpty ? 'Invalid name' : null,
              decoration: kInputDecoration('Name',
                  bgColor: secondaryAppColor, hintColor: Colors.white),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
              decoration: kInputDecoration('Email',
                  bgColor: secondaryAppColor, hintColor: Colors.white),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              validator: (val) =>
                  val!.length < 6 ? 'Required at least 6 chars' : null,
              decoration: kInputDecoration('Password',
                  bgColor: secondaryAppColor, hintColor: Colors.white),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordConfirmController,
              obscureText: true,
              validator: (val) => val != passwordController.text
                  ? 'Confirm password does not match'
                  : null,
              decoration: kInputDecoration('Confirm password',
                  bgColor: secondaryAppColor, hintColor: Colors.white),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 40,
            ),
            loading
                ? const Center(child: CircularProgressIndicator())
                : kTextButton(
                    'Register',
                    () {
                      if (formKey.currentState!.validate()) {
                        _registerUser(); // Call _registerUser directly
                      }
                    },
                    backgroundColor: secondaryAppColor,
                  ),
            const SizedBox(
              height: 20,
            ),
            kLoginRegisterHint('Already have an account? ', 'Login', () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false);
            })
          ],
        ),
      ),
    );
  }
}
