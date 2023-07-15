import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.teal),
                child: ListTile(
                  leading: const CircleAvatar(
                    radius: 40,
                  ),
                  subtitle: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(color: Colors.white38),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "id: 54651561352132135156153",
                        style: TextStyle(color: Colors.white38),
                      )
                    ],
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      FirebaseAuth.instance.currentUser!.email.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 90,
                left: 320,
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 150,
              ),
            ]),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Account",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ListTile(
                    title: Text(
                      "+998 93 397 43 25",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text("Tap to change phone number"),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "None",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text("Username"),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Bio",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text("Add a few words about yourself"),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Settings",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.notifications_none,size: 30,),
                      SizedBox(
                        width: 20,
                      ),
                      Text("asd")
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
