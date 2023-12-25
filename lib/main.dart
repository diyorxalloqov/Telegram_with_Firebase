import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Firebase_chat_app/db/shared.dart';
import 'package:Firebase_chat_app/provider/auth/sign_in_provider.dart';
import 'package:Firebase_chat_app/provider/auth/sign_up_provider.dart';
import 'package:Firebase_chat_app/provider/messageProvider.dart';
import 'package:Firebase_chat_app/ui/pages/splashPage.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageRepository.getInstance();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignUpProvider()),
        ChangeNotifierProvider(create: (context) => SignInProvider()),
        ChangeNotifierProvider(create: (context) => MessageProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
