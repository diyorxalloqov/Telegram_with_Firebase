import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/auth/sign_up_provider.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    SignUpProvider signUpProvider = Provider.of<SignUpProvider>(context);
    return ChangeNotifierProvider(
      create: (context) => SignUpProvider(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: const Text("SignUp Page"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: signUpProvider.emailController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "email"),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: signUpProvider.passwordController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "password"),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              signUpProvider.signUp(context);
            },
            label: signUpProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.red),
                  )
                : const Text("SignUp")),
      ),
    );
  }
}