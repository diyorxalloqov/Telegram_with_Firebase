import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static ImageSource camera = ImageSource.camera;
  static ImageSource galery = ImageSource.gallery;

  static File? selectedImage;
  static XFile? image;

  static Future<void> pickImage(ImageSource source) async {
    try {
      image = await ImagePicker().pickImage(source: source);
      File? img = File(image!.path);
      selectedImage = img;
    } catch (e) {
      debugPrint("Rasm yuklashda xatolik");
    }
  }
}
