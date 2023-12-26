// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:Firebase_chat_app/model/chat_model.dart';
import 'package:Firebase_chat_app/view_model/provider/chat/chat_provider.dart';
import 'package:Firebase_chat_app/view_model/provider/chat/messageProvider.dart';
import 'package:Firebase_chat_app/repository/service/audio_service.dart';

class VoiceChat extends StatefulWidget {
  const VoiceChat({Key? key}) : super(key: key);

  @override
  _VoiceChatState createState() => _VoiceChatState();
}

class _VoiceChatState extends State<VoiceChat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late ChatProvider chatProvider;

  final int _limit = 20;
  List<QueryDocumentSnapshot> listMessage = [];

  String groupChatId = "";
  bool isShowSticker = false;
  final FocusNode focusNode = FocusNode();
  String currentUserId = "";

  AudioController audioController = Get.put(AudioController());
  AudioPlayer audioPlayer = AudioPlayer();
  String audioURL = "";
  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  // record beginning
  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getFilePath();
      RecordMp3.instance.start(recordFilePath, (type) {
        setState(() {});
      });
    } else {}
    setState(() {});
  }

  // record ending
  void stopRecord() async {
    bool stop = RecordMp3.instance.stop();
    audioController.end.value = DateTime.now();
    audioController.calcDuration();
    var ap = AudioPlayer();
    await ap.play(AssetSource("Notification.mp3"));
    ap.onPlayerComplete.listen((a) {});
    if (stop) {
      audioController.isRecording.value = false;
      audioController.isSending.value = true;
      await uploadAudio();
    }
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath =
        "${storageDirectory.path}/record${DateTime.now().microsecondsSinceEpoch}.acc";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "$sdPath/test_${i++}.mp3";
  }

  uploadAudio() async {
    UploadTask uploadTask = chatProvider.uploadAudio(File(recordFilePath),
        "audio/${DateTime.now().millisecondsSinceEpoch.toString()}");
    try {
      TaskSnapshot snapshot = await uploadTask;
      audioURL = await snapshot.ref.getDownloadURL();
      String strVal = audioURL.toString();
      setState(() {
        audioController.isSending.value = false;
        onSendMessage(strVal, TypeMessage.audio,
            duration: audioController.total);
      });
    } on FirebaseException catch (e) {
      setState(() {
        audioController.isSending.value = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  late String recordFilePath;

  void readLocal() async {
    User? currentUser = _auth.currentUser;
    var a = await FirebaseFirestore.instance.collection('chat').get();
    setState(() {
      currentUserId = currentUser!.uid == "Zn6D2VAp8Ue40LOoI2iVFhrLDki1"
          ? a.docs[0].id
          : a.docs[1].id;
    });
    String peerId = currentUser!.uid != "Zn6D2VAp8Ue40LOoI2iVFhrLDki1"
        ? a.docs[0].id
        : a.docs[1].id;
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }
    chatProvider.updateDataFirestore(
      'chat',
      currentUserId,
      {'chattingWith': peerId},
    );
  }

  void onSendMessage(String content, int type, {String? duration = ""}) {
    if (content.trim().isNotEmpty) {
      User? currentUser = _auth.currentUser;
      chatProvider.sendMessage(
          content, type, groupChatId, currentUserId, currentUser.toString(),
          duration: duration!);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing', backgroundColor: Colors.grey);
    }
  }

  @override
  void initState() {
    super.initState();
    chatProvider = Get.put(ChatProvider(
        firebaseFirestore: FirebaseFirestore.instance,
        firebaseStorage: FirebaseStorage.instance));
    focusNode.addListener(onFocusChange);

    readLocal();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  @override
  build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MessageProvider(),
      builder: (context, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Column(
              children: [
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                buildListMessage(),
              ],
            ),
            loading()
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                readOnly: true,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: audioController.isRecording.value
                      ? " Recording audio..."
                      : " Press and holding...",
                  hintStyle: const TextStyle(color: Colors.black),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Obx(() => audioController.isSending.value
                          ? const Text(
                              "Uploading Audio...",
                              style: TextStyle(color: Colors.black),
                            )
                          : GestureDetector(
                              child: const Icon(Icons.mic, color: Colors.black),
                              onLongPress: () async {
                                var audioPlayer = AudioPlayer();
                                await audioPlayer
                                    .play(AssetSource("Notification.mp3"));
                                audioPlayer.onPlayerComplete.listen((a) {
                                  audioController.start.value = DateTime.now();
                                  startRecord();
                                  audioController.isRecording.value = true;
                                });
                              },
                              onLongPressEnd: (details) {
                                stopRecord();
                              },
                            )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  loading() {
    return Positioned(
      child: audioController.isSending.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const SizedBox.shrink(),
    );
  }

  buildListMessage() {
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getChatStream(groupChatId, _limit),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessage = snapshot.data!.docs;
                  if (listMessage.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
                      itemBuilder: (context, index) =>
                          buildItem(index, snapshot.data?.docs[index]),
                      itemCount: snapshot.data?.docs.length,
                      reverse: true,
                    );
                  } else {
                    return const Center(
                        child: Text(
                      "No message here yet...",
                      style: TextStyle(color: Colors.black),
                    ));
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  _audioItem({
    required String message,
    required bool isCurrentUser,
    required int index,
    required String time,
    required String duration,
  }) =>
      Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.black : Colors.black.withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                audioController.onPressedPlayButton(index, message);
              },
              onSecondaryTap: () {
                audioPlayer.stop();
              },
              child: Obx(
                () => (audioController.isRecordPlaying &&
                        audioController.currentId == index)
                    ? Icon(
                        Icons.cancel,
                        color: isCurrentUser ? Colors.white : Colors.black,
                      )
                    : Icon(
                        Icons.play_arrow,
                        color: isCurrentUser ? Colors.white : Colors.black,
                      ),
              ),
            ),
            Obx(
              () => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      LinearProgressIndicator(
                        minHeight: 5,
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCurrentUser ? Colors.white : Colors.black,
                        ),
                        value: (audioController.isRecordPlaying &&
                                audioController.currentId == index)
                            ? audioController.completedPercentage.value
                            : audioController.totalDuration.value.toDouble(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              duration,
              style: TextStyle(
                  fontSize: 12,
                  color: isCurrentUser ? Colors.white : Colors.black),
            ),
          ],
        ),
      );

  buildItem(int index, DocumentSnapshot? document) {
    if (document != null) {
      MessageChat messageChat = MessageChat.fromDocument(document);
      if (messageChat.idFrom == currentUserId) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (messageChat.type == TypeMessage.audio)
                _audioItem(
                    message: messageChat.content,
                    isCurrentUser: messageChat.idFrom == currentUserId,
                    index: index,
                    time: messageChat.timestamp.toString(),
                    duration: messageChat.duration.toString())
            ],
          ),
        );
      } else {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  isLastMessageLeft(index)
                      ? Material(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(18),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Container(color: Colors.red),
                        )
                      : Container(width: 35),
                  if (messageChat.type == TypeMessage.audio)
                    _audioItem(
                        message: messageChat.content,
                        isCurrentUser: messageChat.idFrom == currentUserId,
                        index: index,
                        time: messageChat.timestamp.toString(),
                        duration: messageChat.duration.toString())
                ],
              ),

              // Time
              isLastMessageLeft(index)
                  ? Container(
                      margin:
                          const EdgeInsets.only(left: 50, top: 5, bottom: 5),
                      child: Text(
                        DateFormat('dd MMM kk:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(messageChat.timestamp))),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage[index - 1].get("idFrom") == currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage[index - 1].get("idFrom") != currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }
}
