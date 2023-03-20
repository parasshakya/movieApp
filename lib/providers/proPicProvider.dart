import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final proPicProvider = StateNotifierProvider.autoDispose<ProPicNotifier,XFile?>((ref) => ProPicNotifier(null));

class ProPicNotifier extends StateNotifier<XFile?> {
  ProPicNotifier(super.state);

  void pickAnImage() async {
    final ImagePicker _picker = ImagePicker();
    state = await _picker.pickImage(source: ImageSource.gallery);
  }
}
