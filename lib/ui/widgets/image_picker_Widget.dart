// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telegram/service/ImagePickerService.dart';
import 'package:telegram/service/fireStorageService.dart';
import 'package:telegram/service/fireStore_Service.dart';

class ImagePickerWidget extends StatefulWidget {
  final dynamic title;
  const ImagePickerWidget({super.key, required this.title});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  bool isUploaded = false;
  @override
  void initState() {
    ImagePickerService.selectedImage = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      content: ImagePickerService.selectedImage != null
          ? Image.file(ImagePickerService.selectedImage!)
          : const SizedBox.shrink(),
      actions: [
        !isUploaded
            ? Column(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        await ImagePickerService.pickImage(
                          ImagePickerService.camera,
                        );
                        setState(() {
                          isUploaded = true;
                        });
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.camera),
                          Text("Camera"),
                        ],
                      )),
                  ElevatedButton(
                      onPressed: () async {
                        await ImagePickerService.pickImage(
                            ImagePickerService.galery);
                        setState(() {
                          isUploaded = true;
                        });
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.image),
                          Text("Galery"),
                        ],
                      ))
                ],
              )
            : ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await FireStorageService.uploadFile(
                          ImagePickerService.selectedImage!)
                      .then((value) async {
                    await FireStoreService.writeToDB(
                        message: FireStorageService.uploadedFilePath,
                        from: FirebaseAuth.instance.currentUser!.email
                            .toString());
                  });
                },
                child: const Text("ok"))
      ],
    );
  }
}
