import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onSelectImage});
  final void Function(File? pickedImage) onSelectImage;
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? userImage;

  void _pickUserImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      userImage = File(pickedImage.path);
    });

    widget.onSelectImage(userImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: userImage == null ? null : FileImage(userImage!),
        ),
        TextButton.icon(
          onPressed: _pickUserImage,
          icon: const Icon(Icons.image),
          label: const Text('Add image'),
        )
      ],
    );
  }
}
