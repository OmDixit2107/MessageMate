import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserimgPicker extends StatefulWidget {
  const UserimgPicker({super.key, required this.onpickimg});
  final void Function(File pickedimg) onpickimg;
  @override
  State<UserimgPicker> createState() {
    return _UserimgPickerState();
  }
}

class _UserimgPickerState extends State<UserimgPicker> {
  File? _pickedimg;
  void _imagepicker() async {
    final pickimg = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickimg == null) {
      return;
    }
    setState(() {
      _pickedimg = File(pickimg.path);
    });
    widget.onpickimg(_pickedimg!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: _pickedimg != null ? FileImage(_pickedimg!) : null,
        ),
        TextButton.icon(
          icon: const Icon(Icons.image),
          onPressed: _imagepicker,
          label: const Text("Add Image"),
        ),
      ],
    );
  }
}
