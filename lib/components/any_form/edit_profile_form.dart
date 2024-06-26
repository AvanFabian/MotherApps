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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _txtControllerName = TextEditingController();
  final TextEditingController _txtControllerEmail = TextEditingController();
  final TextEditingController _txtControllerEmailConfirm =
      TextEditingController();
  bool _loading = false;
  File? _imageFile;
  final _picker = ImagePicker();

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
    if (apiResponse.data is User) {
      User user = apiResponse.data as User;
      _txtControllerName.text = user.name ?? '';
      _txtControllerEmail.text = user.email ?? '';
    } else {
      print('Unexpected data format: ${apiResponse.data}');
    }
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      String name = _txtControllerName.text;
      String email = _txtControllerEmail.text;
      String emailConfirmation = _txtControllerEmailConfirm.text;

      ApiResponse response =
          await updateUser(name, email, emailConfirmation, _imageFile);
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            // Add this
            child: Column(
              children: <Widget>[
                if (_imageFile != null) Image.file(_imageFile!),
                const IconButton(
                  icon: Icon(Icons.photo_library),
                  // onPressed: getImage,
                  onPressed: null,
                  tooltip: 'Select Image from Gallery',
                ),
                TextFormField(
                  controller: _txtControllerName,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _txtControllerEmail,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _txtControllerEmailConfirm,
                  decoration: const InputDecoration(labelText: 'Confirm Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm Email is required';
                    }
                    if (value != _txtControllerEmail.text) {
                      return 'Email does not match';
                    }
                    return null;
                  },
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
      ),
    );
  }
}
