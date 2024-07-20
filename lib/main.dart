import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add Firebase Auth import
import 'package:chat_app/screens/auth_provider.dart';
import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_provider.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProviders()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthenticationWithWrapper(),
      ),
    );
  }
}

class AuthenticationWithWrapper extends StatefulWidget {
  const AuthenticationWithWrapper({Key? key});

  @override
  _AuthenticationWithWrapperState createState() =>
      _AuthenticationWithWrapperState();
}

class _AuthenticationWithWrapperState extends State<AuthenticationWithWrapper> {
  // Initialize FirebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Or another loading indicator
        } else if (snapshot.hasData) {
          return HomeScreen(); // User is signed in
        } else {
          return LoginScreen(); // User is not signed in
        }
      },
    );
  }
}
