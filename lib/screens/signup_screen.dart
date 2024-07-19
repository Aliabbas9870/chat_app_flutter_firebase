import 'dart:io';

import 'package:chat_app/screens/auth_provider.dart';
import 'package:chat_app/screens/auth_provider.dart';
import 'package:chat_app/screens/auth_provider.dart';
import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  File? _image;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> _pickImage() async {
    final PickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
      }
    });
  }

  Future<String> _uploadImage(File image) async {
    final ref = _storage
        .ref()
        .child('user_image')
        .child('${_auth.currentUser!.uid}.jpg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  Future<void> signUp() async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passController.text);
      final ImageUrl = await _uploadImage(_image!);
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'name': _nameController.text,
        'email': _emailController.text,
        'iamgeUrl': ImageUrl
      });
      // Fluttertoast.showToast(msg: "Sign up Success");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));

      // Fluttertoast.showToast(
      //     msg: "Sign up is Success",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final AuthProvider = Provider.of<AuthProviders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(),
                  ),
                  child: _image == null
                      ? Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.blue,
                            size: 50,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: "Name", border: OutlineInputBorder()),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Please Enter a Name";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: "Email", border: OutlineInputBorder()),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Please Enter a Email";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _passController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Password", border: OutlineInputBorder()),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Please Enter a Password";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                height: 50,
                child: ElevatedButton(
                    onPressed: signUp,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    child: Text(
                      "Create Account",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Text("OR"),
              SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text(
                    "Login Account",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
