



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';


final toggleProvider = StateNotifierProvider<ToggleNotifier,bool>((ref) => ToggleNotifier(true));

class ToggleNotifier extends StateNotifier<bool>{
  ToggleNotifier(super.state);
  void change(){
    state = !state;
  }
}

