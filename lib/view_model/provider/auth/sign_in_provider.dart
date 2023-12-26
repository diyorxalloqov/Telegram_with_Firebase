import 'package:Firebase_chat_app/ui/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class SignInProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  String error = '';

  Future<void> signIn(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        error = "oldin royxatdan otmagansiz  ";
        debugPrint(error);
        notifyListeners();
      } else if (e.code == "wrong-password") {
        error = "Parol noto'g'ri";
        debugPrint(error);
        notifyListeners();
      } else {
        debugPrint("unknown");
      }
    }
  }
}
