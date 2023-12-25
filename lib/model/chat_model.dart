
import 'package:cloud_firestore/cloud_firestore.dart';

class TypeMessage {
  static const text = 0;
  static const image = 1;
  static const audio = 3;
}

class MessageChat {
  String idFrom;
  String idTo;
  String timestamp;
  String content;
  int type;
  String? duration;

  MessageChat(
      {required this.idFrom,
      required this.idTo,
      required this.timestamp,
      required this.content,
      required this.type,
      this.duration});

  Map<String, dynamic> toJson() {
    return {
      "idFrom": idFrom,
      "idTo": idTo,
      "timestamp": timestamp,
      "content": content,
      "type": type,
      "duration": duration
    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get('idFrom');
    String idTo = doc.get('idTo');
    String timestamp = doc.get('timestamp');
    String content = doc.get('content');
    int type = doc.get('type');
    String duration = doc.get('duration');
    return MessageChat(
        idFrom: idFrom,
        idTo: idTo,
        duration: duration,
        timestamp: timestamp,
        content: content,
        type: type);
  }
}