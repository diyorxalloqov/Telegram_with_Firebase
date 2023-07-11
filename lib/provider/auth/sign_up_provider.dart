import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telegram/ui/pages/homePage.dart';

class SignUpProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  String error = '';

  Future<void> signUp(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
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
