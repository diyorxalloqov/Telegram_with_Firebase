import 'package:Firebase_chat_app/firebase_options.dart';
import 'package:Firebase_chat_app/repository/service/firebase_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Firebase_chat_app/repository/db/shared.dart';
import 'package:Firebase_chat_app/view_model/provider/auth/sign_in_provider.dart';
import 'package:Firebase_chat_app/view_model/provider/auth/sign_up_provider.dart';
import 'package:Firebase_chat_app/view_model/provider/chat/messageProvider.dart';
import 'package:Firebase_chat_app/ui/pages/splashPage.dart';

/////   for background messaging working on background
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageRepository.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  FirebaseMessaging.onBackgroundMessage((_firebaseMessagingBackgroundHandler));
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
