import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

///  firebasega file yuklash  

class FireStorageService {

  static String uploadedFilePath = '';

  static Future<void> uploadFile(File file,) async {
    try {
      String fileName = basename(file.path);
      TaskSnapshot snapshot = await FirebaseStorage.instance.ref().child("profile/$fileName").putFile(file);
    uploadedFilePath = await snapshot.ref.getDownloadURL();
    }on FirebaseException catch (e) {
      debugPrint(e.message.toString());
    }
  }
}
