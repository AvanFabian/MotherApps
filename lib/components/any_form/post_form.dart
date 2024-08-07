import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:monitoring_hamil/res/constants.dart';
import 'package:monitoring_hamil/models/api_response.dart';
import 'package:monitoring_hamil/models/post.dart';
import 'package:monitoring_hamil/services/post_service.dart';
import 'package:monitoring_hamil/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../auth/login_page.dart';

class PostForm extends StatefulWidget {
  final Post? post;
  final String? title;

  const PostForm({super.key, this.post, this.title});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final GlobalKey<FormState> _formKeyHeader = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySubHeader = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyBody = GlobalKey<FormState>();
  final TextEditingController _txtControllerHeader = TextEditingController();
  final TextEditingController _txtControllerSubHeader = TextEditingController();
  final TextEditingController _txtControllerBody = TextEditingController();
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

  void _createPost() async {
    String? image = _imageFile == null ? null : getStringImage(_imageFile);
    ApiResponse response = await createPost(_txtControllerHeader.text,
        _txtControllerSubHeader.text, _txtControllerBody.text, image);

    if (response.error == null) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else if (response.error == unauthorized) {
      logout(context).then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false)
          });
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

  // edit post
  void _editPost(int postId) async {
    String header = _txtControllerHeader.text;
    String subheader = _txtControllerSubHeader.text;
    String body = _txtControllerBody.text;

    ApiResponse response = await editPost(
        postId, header, subheader, body, getStringImage(_imageFile));
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

  @override
  void initState() {
    if (widget.post != null) {
      _txtControllerBody.text = widget.post!.body ?? '';
      _txtControllerHeader.text = widget.post!.header ?? '';
      _txtControllerSubHeader.text = widget.post!.subheader ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    padding: const EdgeInsets.all(6),
                    strokeWidth: 1,
                    dashPattern: const [6, 4],
                    child: Container(
                      // your container
                      margin: const EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      decoration: BoxDecoration(
                        image: _imageFile == null
                            ? null
                            : DecorationImage(
                                image: FileImage(_imageFile ?? File('')),
                                fit: BoxFit.cover),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.image,
                                size: 50, color: Colors.black38),
                            onPressed: () {
                              getImage();
                            },
                          ),
                          const Text('Add photos / images'),
                        ],
                      ),
                    ),
                  ),
                ),
                Form(
                  key: _formKeyHeader,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _txtControllerHeader,
                      validator: (val) =>
                          val!.isEmpty ? 'Title Text is required' : null,
                      decoration: const InputDecoration(
                          hintText: "Title...",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black38))),
                    ),
                  ),
                ),
                Form(
                  key: _formKeySubHeader,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _txtControllerSubHeader,
                      validator: (val) =>
                          val!.isEmpty ? 'Sub Title is required' : null,
                      decoration: const InputDecoration(
                          hintText: "Sub Title...",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black38))),
                    ),
                  ),
                ),
                Form(
                  key: _formKeyBody,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _txtControllerBody,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      validator: (val) =>
                          val!.isEmpty ? 'Post body is required' : null,
                      decoration: const InputDecoration(
                          hintText: "What's on your mind?...",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black38))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: kTextButton('PUBLISH', () {
                    if (_formKeyHeader.currentState!.validate() &&
                        _formKeySubHeader.currentState!.validate() &&
                        _formKeyBody.currentState!.validate()) {
                      setState(() {
                        _loading = !_loading;
                      });
                      if (widget.post == null) {
                        _createPost();
                      } else {
                        _editPost(widget.post!.id ?? 0);
                      }
                    }
                  }),
                )
              ],
            ),
    );
  }
}
