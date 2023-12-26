import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Firebase_chat_app/repository/service/fireStore_Service.dart';

class MessageProvider extends ChangeNotifier {
  bool isLoading = false;
  String error = '';

  TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  Future<void> sendMessage() async {
    isLoading = true;
    notifyListeners();
    dynamic response = await FireStoreService.writeToDB(
        message: messageController.text,
        from: FirebaseAuth.instance.currentUser!.email.toString());
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    if (response == true) {
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      error = response;
      notifyListeners();
    }
    messageController.clear();
  }

  final Stream<QuerySnapshot> message = FirebaseFirestore.instance
      .collection("chat")
      .orderBy('created_at')
      .snapshots();
}
