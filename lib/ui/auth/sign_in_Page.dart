import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Firebase_chat_app/ui/auth/sign_up_Page.dart';

import '../../provider/auth/sign_in_provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    SignInProvider signInProvider = Provider.of<SignInProvider>(context);
    return ChangeNotifierProvider(
      create: (context) => SignInProvider(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: const Text("SignIn Page"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: signInProvider.emailController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "email"),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: signInProvider.passwordController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "password"),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()));
                  },
                  child: const Text("Sign Up now"))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              signInProvider.signIn(context);
            },
            label: signInProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.red),
                  )
                : const Text("SignUp")),
      ),
    );
  }
}
