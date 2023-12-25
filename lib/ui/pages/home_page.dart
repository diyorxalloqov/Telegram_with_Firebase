import 'package:flutter/material.dart';
import 'package:Firebase_chat_app/ui/pages/message_page.dart';
import 'package:Firebase_chat_app/ui/pages/voice_chat.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Messaging"),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('message'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MessagePage())),
            trailing: const Icon(Icons.arrow_forward),
          ),
          ListTile(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const VoiceChat())),
            title: const Text("voice message"),
            trailing: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
