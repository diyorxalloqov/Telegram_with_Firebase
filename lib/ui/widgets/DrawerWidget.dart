// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telegram/ui/pages/settingsPage.dart';
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
          ListTile(
            onTap: () {},
            title: const Text("New Group"),
            leading: const Icon(Icons.people),
          ),
          ListTile(
            onTap: () {},
            title: const Text("New Secter Chat"),
            leading: const Icon(Icons.lock_outline_rounded),
          ),
          ListTile(
            onTap: () {},
            title: const Text("New Channel"),
            leading: const Icon(Icons.change_circle),
          ),
          const Divider(
            thickness: 2,
          ),
          ListTile(
            onTap: () {},
            title: const Text("Contacts"),
            leading: const Icon(Icons.person),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Chat Folders"),
            leading: const Icon(Icons.drive_file_move_outlined),
          ),
          ListTile(
            onTap: () {},
            title: const Text("People Nearby"),
            leading: const Icon(Icons.location_on_outlined),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Saved Messages"),
            leading: const Icon(Icons.bookmark_border),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Calls"),
            leading: const Icon(Icons.call_outlined),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const SettingsPage())));
            },
            title: const Text("Settings"),
            leading: const Icon(Icons.settings),
          ),
          const Divider(
            thickness: 2,
          ),
          ListTile(
            onTap: () {},
            title: const Text("Plus Settings"),
            leading: const Icon(Icons.add_circle_outline_outlined),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Categories"),
            leading: const Icon(Icons.drive_file_move_outlined),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Download themes"),
            leading: const Icon(Icons.color_lens_outlined),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Theming"),
            leading: const Icon(Icons.brush_outlined),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Support group"),
            leading: const Icon(Icons.people),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Chat Counters"),
            leading: const Icon(Icons.menu),
          ),
        ],
      ),
    );
  }

  //  emaildan faqat ismni olish uchun

  String findIsFake(String v) {
    String result = '';
    bool isStopped = false;
    for (int i = 0; i < v.length; i++) {
      if (v[i] == "@") {
        isStopped = true;
        break; // Exit the loop after finding the '@' symbol
      }
      result += v[i];
    }
    debugPrint(result);
    return result;
  }
}
