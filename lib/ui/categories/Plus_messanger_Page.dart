// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telegram/provider/auth/sign_up_provider.dart';
import 'package:telegram/ui/pages/messagePage.dart';

class PlusMessengerPage extends StatefulWidget {
  const PlusMessengerPage({Key? key}) : super(key: key);

  @override
  _PlusMessengerPageState createState() => _PlusMessengerPageState();
}

class _PlusMessengerPageState extends State<PlusMessengerPage> {
  @override
  Widget build(BuildContext context) {
    SignUpProvider signUpProvider = Provider.of<SignUpProvider>(context);
    return ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MessagePage()),
              );
            },
            leading: const CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                "https://cdn.pixabay.com/photo/2016/10/21/14/50/plouzane-1758197_1280.jpg",
              ),
            ),
            title: Row(
              children: [
                const Icon(
                  Icons.person,
                  size: 20,
                ),
                Text(signUpProvider.usersList[index]["User"]),
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
        itemCount: signUpProvider.usersList.length);
  }
}
