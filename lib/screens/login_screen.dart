import 'package:chat_app/screens/auth_provider.dart';
import 'package:chat_app/screens/auth_provider.dart';
import 'package:chat_app/screens/auth_provider.dart';
import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final AuthProvider = Provider.of<AuthProviders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  onPressed: () async {
                    try {
                      await AuthProvider.signin(
                          _emailController.text, _passController.text);
                      // Fluttertoast.showToast(msg: "Sign in Success");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    } catch (ex) {}
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                  child: Text(
                    "Sing In",
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
                      MaterialPageRoute(builder: (context) => SignupScreen()));
                },
                child: Text(
                  "Create Account",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ))
          ],
        ),
      ),
    );
  }
}
