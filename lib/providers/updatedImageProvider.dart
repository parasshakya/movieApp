
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final updatedImageProvider = StateNotifierProvider.autoDispose<UpdatedImageNotifier,XFile?>((ref) => UpdatedImageNotifier(null));

class UpdatedImageNotifier extends StateNotifier<XFile?>{
  UpdatedImageNotifier(super.state);

  Future<void> pickAnImage() async {
    final ImagePicker _picker = ImagePicker();
    state = await _picker.pickImage(source: ImageSource.gallery);

  }


}