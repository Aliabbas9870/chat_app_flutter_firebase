import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot> getChats(String uid) {
    return _firestore
        .collection("chats")
        .where('users', arrayContains: uid)
        .snapshots();
  }

  Stream<QuerySnapshot> searchUser(String query) {
    return _firestore
        .collection("users")
        .where('email', isGreaterThanOrEqualTo: query)
        .where('email', isGreaterThanOrEqualTo: query + '\uf8ff')
        .snapshots();
  }

  Future<void> sendMessage(
      String chatId, String message, String receiverId) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('message')
          .add({
        'senderId': currentUser.uid,
        'receiverId': receiverId,
        'messageBody': message,
        'timestamp': FieldValue.serverTimestamp()
      });

      await _firestore.collection('chats').doc(chatId).set({
        'user': [currentUser.uid, receiverId],
        'lastMessage': message,
        'timestamp': FieldValue.serverTimestamp()
      }, SetOptions(merge: true));
    }
  }

  Future<String?> getChatRoom(String receiverId) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final chatQuery = await _firestore
          .collection('chats')
          .where('users', arrayContains: currentUser.uid)
          .get();
      final chats = chatQuery.docs
          .where((chat) => chat['users'].contains(receiverId))
          .toList();
      if (chats.isNotEmpty) {
        return chats.first.id;
      }
    }
    return null;
  }

  Future<String> createChatRoom(String receiverId) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final chatRoom = await _firestore.collection('chats').add({
        'user': [currentUser.uid, receiverId],
        'lastMessage': '',
        'timestamp': FieldValue.serverTimestamp()
      });
      return chatRoom.id;
    }
    throw Exception("Current user is Null");
  }
}
