import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

//  for chat
//   chatlashish  uchun service

class FireStoreService {
  static CollectionReference chat =
      FirebaseFirestore.instance.collection("chat");
  static Future<dynamic> writeToDB(
      {required String message, required String from}) async {
    try {
      await chat.add({
        "message": message,
        "from": from,
        "created_at": FieldValue.serverTimestamp()
      });
      return true;
    } on FirebaseException catch (e) {
      return e.message.toString();
    }
  }

  static Future<void> deleteFromDB(String id) async {
    await chat.doc(id).delete();
  }

  static Future<void> updateDB(
      String id,TextEditingController controller) async {
    await chat.doc(id).update({
      "message": controller.text.toString(),
      "from": FirebaseAuth.instance.currentUser!.email,
      "created_at": FieldValue.serverTimestamp()
    });
  }
}
