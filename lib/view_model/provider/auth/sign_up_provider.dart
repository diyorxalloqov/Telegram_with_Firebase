// ignore_for_file: avoid_function_literals_in_foreach_calls, non_constant_identifier_names, unused_local_variable, use_build_context_synchronously

import 'package:Firebase_chat_app/ui/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  String error = '';
  CollectionReference users = FirebaseFirestore.instance.collection("Users");
  List<Map<String, dynamic>> usersList = [];

  Future<void> signUp(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      DocumentReference<Object?> AllUsers =
          await users.add({"User": emailController.text});

      // Firebaseda account qoshish va uni ui ga chiqarish

      await FirebaseFirestore.instance
          .collection("Users")
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((DocumentSnapshot docSnapshot) {
          usersList.add(docSnapshot.data() as Map<String, dynamic>);
          List<String> usersListAsString =
              usersList.map((user) => user.toString()).toList();
          // StorageRepository.putList('users', usersListAsString);
        });
      });

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        error = "Parolingiz juda kuchsiz";
        debugPrint(error);
        notifyListeners();
      } else if (e.code == "email-already-in-use") {
        error = "Bu email allqachon mavjud";
        debugPrint(error);
        notifyListeners();
      } else {
        debugPrint("unknown");
      }
    }
  }
}
