// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:telegram/ui/pages/messagePage.dart';

class PlusMessengerPage extends StatelessWidget {
  const PlusMessengerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MessagePage()));
          },
          leading: const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
                "https://cdn.pixabay.com/photo/2016/10/21/14/50/plouzane-1758197_1280.jpg"),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.person,
                size: 20,
              ),
              Text("Telegram"),
            ],
          ),
          trailing: Text(DateTime.now().toString().substring(10, 16)),
          subtitle: Row(
            children: [
              Text(
                "Data :",
                style: TextStyle(
                  color: Colors.teal.shade600,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Text("asd")
            ],
          ),
        );
      },
      itemCount: 10,
    );
  }
}
