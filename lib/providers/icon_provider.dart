import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final iconProvider = ChangeNotifierProvider((ref) => IconProvider());

class IconProvider extends ChangeNotifier{

Icon icon = Icon(Icons.thumb_up_alt_outlined);

void changeIconToLike(){
  icon = Icon(Icons.thumb_up);
  notifyListeners();
}

void changeIconToDisLike(){
  icon = Icon(Icons.thumb_up_alt_outlined);
  notifyListeners();
}

}