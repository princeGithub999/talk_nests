import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:talk_nest/model/auth_model/auth_model.dart';

import '../../model/contacts_model/contacts_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<UserCredential> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> saveUserData(String currentUserID, AuthModel userData) async {
    await db
        .collection('Chatting_UserData')
        .doc(currentUserID)
        .set(userData.toMap());
  }

  Future<void> addChatNumber(ContactsModel chatData) async {
    await db.collection('Chat_Number').doc().set(chatData.toMap());
  }

  Future<AuthModel?> getCurrentUser() async {
    DocumentSnapshot doc = await db
        .collection('Chatting_UserData')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (doc.exists && doc.data() != null) {
      return AuthModel.fromMap(doc.data() as Map<String, dynamic>);
    } else {
      Fluttertoast.showToast(msg: 'User data not found!');
    }
    return null;
  }

  Future<List<AuthModel>> fetchProfileData() async {
    try {
      final snapshot = await db.collection('Chatting_UserData').get();
      return snapshot.docs.map((doc) {
        return AuthModel.fromMap(doc.data());
      }).toList();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error fetching profile data: $e');
      debugPrint("Error fetching profile data: $e");
      return [];
    }
  }

  Future<String> uploadProfileImage(
      File imageFile, String currentUserID) async {
    final ref = storage.ref().child('Chatting_Profile_image/$currentUserID');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<bool> checkUserLoginStutas() async {
    if (_auth.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateProfileData(Map<String, dynamic> data) async {
    await db
        .collection('Chatting_UserData')
        .doc(_auth.currentUser!.uid)
        .update(data);
  }
}
