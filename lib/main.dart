import 'package:chat_app/screens/auth_provider.dart';
import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_provider.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProviders(),
        ),
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
  const AuthenticationWithWrapper({super.key});

  @override
  State<AuthenticationWithWrapper> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AuthenticationWithWrapper> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviders>(
      builder: (context, authProviders, child) {
        if (authProviders==null) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
