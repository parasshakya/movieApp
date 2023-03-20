import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final imageProvider = StateNotifierProvider.autoDispose<ImageNotifier,XFile?>((ref) => ImageNotifier(null));

class ImageNotifier extends StateNotifier<XFile?>{
  ImageNotifier(super.state);

  void pickAnImage() async {
    final ImagePicker _picker = ImagePicker();
    state = await _picker.pickImage(source: ImageSource.gallery);

  }


}