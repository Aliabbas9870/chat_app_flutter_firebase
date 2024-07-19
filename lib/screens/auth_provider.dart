import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AuthProviders with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get currentuser => _auth.currentUser;
  bool get isSignin => currentuser != null;
  Future<void> signin(
    String email,
    String password,
  ) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    notifyListeners();

    // Future<void> signUp(
    //     String email, String password, String name, String imageUrl) async {
    //   UserCredential credential = await _auth.createUserWithEmailAndPassword(
    //       email: email, password: password);
    //   await _firestore.collection('users').doc(credential.user!.uid).set({
    //     'uid': credential.user!.uid,
    //     'user': name,
    //     'email': email,
    //     'iamgeUrl': imageUrl
    //   });
    //   notifyListeners();
    // }

    Future<void> signOut() async {
      await _auth.signOut();
      notifyListeners();
    }
  }
}
