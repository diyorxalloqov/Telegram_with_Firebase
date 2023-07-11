// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telegram/ui/widgets/image_picker_Widget.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
              currentAccountPicture: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => const ImagePickerWidget(
                          title: Text("Rasmni tanlang")));
                },
                child: CircleAvatar(
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : null,
                    child: user.photoURL == null
                        ? Text(
                            user.email.toString()[0],
                            style: const TextStyle(fontSize: 30),
                          )
                        : null),
              ),
              decoration: const BoxDecoration(color: Colors.teal),
              accountName: Text(findIsFake(user.email.toString())),
              accountEmail: Text(user.email.toString())),
        ],
      ),
    );
  }

  String findIsFake(String v) {
    String result = '';
    bool isStarted = true;
    for (var i = 0; i < v.length; i++) {
      if (v[i] == "@") {
        isStarted = false;
      }
      if (isStarted = false) {
        result += v[i];
      } else {
        continue;
      }
    }
    debugPrint(result);
    return result;
  }
}
