import 'dart:io';

import 'package:monitoring_hamil/components/auth/login_page.dart';
import 'package:monitoring_hamil/models/user.dart';
import 'package:monitoring_hamil/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:monitoring_hamil/res/constants.dart';
import 'package:monitoring_hamil/models/api_response.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() =>
      _EditProfileFormState(); // _EditProfileFormState is a class defined below
}

class _EditProfileFormState extends State<EditProfileForm> {
  final GlobalKey<FormState> _formKeyName = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyEmail = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyEmailConfirm = GlobalKey<FormState>();
  final TextEditingController _txtControllerName = TextEditingController();
  final TextEditingController _txtControllerEmail = TextEditingController();
  final TextEditingController _txtControllerEmailConfirm =
      TextEditingController();
  bool _loading = false;
  File? _imageFile;
  final _picker = ImagePicker();
  late int userId;

  Future getImage() async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() async {
    ApiResponse apiResponse = await getUserDetail();
    userId = await getUserId();
    if (apiResponse.data is User) {
      User user = apiResponse.data as User;
      _txtControllerName.text = user.name ?? '';
      _txtControllerEmail.text = user.email ?? '';
    } else {
      print('Unexpected data format: ${apiResponse.data}');
    }
  }

  void _updateProfile() async {
    if (_formKeyName.currentState!.validate() &&
        _formKeyEmail.currentState!.validate() &&
        _formKeyEmailConfirm.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      String name = _txtControllerName.text;
      String email = _txtControllerEmail.text;
      String emailConfirmation = _txtControllerEmailConfirm.text;

      ApiResponse response = await updateUser(
          name, email, emailConfirmation, getStringImage(_imageFile));
      if (response.error == null) {
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else if (response.error == unauthorized) {
        if (mounted) {
          logout(context).then((value) => {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false)
              });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${response.error}')));
        }
        setState(() {
          _loading = !_loading;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_imageFile != null) Image.file(_imageFile!),
              IconButton(
                icon: const Icon(Icons.photo_library),
                onPressed: () {
                  getImage();
                },
                tooltip: 'Select Image from Gallery',
              ),
              Form(
                key: _formKeyName,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _txtControllerName,
                    validator: (val) =>
                        val!.isEmpty ? 'Name is required' : null,
                    decoration: const InputDecoration(
                        hintText: "Name...",
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black38))),
                  ),
                ),
              ),
              Form(
                key: _formKeyEmail,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _txtControllerEmail,
                    validator: (val) =>
                        val!.isEmpty ? 'Email is required' : null,
                    decoration: const InputDecoration(
                        hintText: "Email...",
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black38))),
                  ),
                ),
              ),
              Form(
                key: _formKeyEmailConfirm,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _txtControllerEmailConfirm,
                    validator: (val) =>
                        val!.isEmpty ? 'Confirm Email is required' : null,
                    decoration: const InputDecoration(
                        hintText: "Confirm Email...",
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black38))),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _updateProfile,
                      child: const Text('Update Profile'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
