import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Firebase_chat_app/view_model/provider/chat/messageProvider.dart';
import 'package:Firebase_chat_app/repository/service/fireStore_Service.dart';
import 'package:Firebase_chat_app/ui/widgets/image_picker_Widget.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController updateController = TextEditingController();

    User _user = FirebaseAuth.instance.currentUser!;

    Size mQ = MediaQuery.sizeOf(context);

    MessageProvider messageProvider = Provider.of<MessageProvider>(context);

    return ChangeNotifierProvider(
      create: (context) => MessageProvider(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: ListTile(
            leading: const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://cdn.pixabay.com/photo/2016/10/21/14/50/plouzane-1758197_1280.jpg"),
            ),
            title: Text(
              _user.email.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              "last seen at ${DateTime.now().toString().substring(11, 16)}",
              style: const TextStyle(color: Colors.white54),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: mQ.width,
                child: Container(
                  height: mQ.height * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade200,
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: messageProvider.message,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else {
                        List<Map<String, dynamic>> data = [];
                        List<dynamic> ids = [];
                        snapshot.data!.docs.map((DocumentSnapshot e) {
                          ids.add(e.id);
                          data.add(e.data() as Map<String, dynamic>);
                        }).toList();
                        return data.isEmpty
                            ? const Center(
                                child: Text("Xabarlar mavjud emas"),
                              )
                            : ListView.builder(
                                controller: messageProvider.scrollController,
                                itemBuilder: (context, index) {
                                  return data[index]["message"]
                                          .toString()
                                          .contains("https://")
                                      ? Dismissible(
                                          key: UniqueKey(),
                                          onDismissed:
                                              (DismissDirection direction) {
                                            if (direction ==
                                                DismissDirection.endToStart) {
                                              FireStoreService.deleteFromDB(
                                                  ids[index]);
                                            }
                                          },
                                          child: Align(
                                            alignment: data[index]["from"] ==
                                                    _user.email
                                                ? Alignment.centerLeft
                                                : Alignment.centerRight,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 200,
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.5,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            data[index]
                                                                ['message']),
                                                        fit: BoxFit.cover)),
                                              ),
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onLongPress: () {
                                            data[index]["from"] == _user.email
                                                ? showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: TextFormField(
                                                            controller:
                                                                updateController,
                                                          ),
                                                          actions: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  data[index]["from"] ==
                                                                          _user
                                                                              .email
                                                                      ? FireStoreService.updateDB(
                                                                          ids[index],
                                                                          updateController)
                                                                      : null;
                                                                  updateController
                                                                      .clear();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    "Yangilash")),
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    "Orqaga")),
                                                          ],
                                                        ))
                                                : null;
                                          },
                                          child: Dismissible(
                                            key: UniqueKey(),
                                            onDismissed:
                                                (DismissDirection direction) {
                                              if (direction ==
                                                  DismissDirection.endToStart) {
                                                data[index]['from'] ==
                                                        _user.email
                                                    ? FireStoreService
                                                        .deleteFromDB(
                                                            ids[index])
                                                    : null;
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: data[index]['from'] ==
                                                      _user.email
                                                  ? Text(
                                                      data[index]['message'],
                                                      style: const TextStyle(
                                                          backgroundColor:
                                                              Colors.white,
                                                          fontSize: 17,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          color: Colors.black),
                                                    )
                                                  : Text(data[index]['message'],
                                                      style: const TextStyle(
                                                          backgroundColor:
                                                              Colors.white,
                                                          fontSize: 17,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          color: Colors.black)),
                                            ),
                                          ),
                                        );
                                },
                                itemCount: data.length,
                              );
                      }
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        controller: messageProvider.messageController,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'message',
                          hintStyle: const TextStyle(color: Colors.black),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const ImagePickerWidget(
                                              title: Text("Faylni tanlang")));
                                },
                                icon: const Icon(
                                  Icons.file_copy_outlined,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  messageProvider.messageController.text.isEmpty
                                      ? null
                                      : messageProvider.sendMessage();
                                },
                                icon: messageProvider.isLoading
                                    ? const CircularProgressIndicator.adaptive()
                                    : const Icon(
                                        Icons.send,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
