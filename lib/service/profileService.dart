import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:telegram/service/ImagePickerService.dart';

class ProfileService {
  static Future<void> updateProfile() async {
    await FirebaseAuth.instance.currentUser!
        .updatePhotoURL(ImagePickerService.selectedImage.toString());
    debugPrint("Profile picture updated");
    return;
  }
}
