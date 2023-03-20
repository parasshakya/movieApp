
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_2/common/firebase_instances.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:image_picker/image_picker.dart';

class AuthService{


  static Future<Either<String,bool>> userSignup({
    required String username,
    required String email,
    required String password,
    required XFile image
}) async {
    try{
      final response = await FirebaseInstances.firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      final imageId = DateTime.now().toString();
      final ref = FirebaseInstances.firebaseStorage.ref().child('userImage/$imageId');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      final token = await FirebaseInstances.firebaseMessaging.getToken();

      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          firstName: username,
          id: response.user!.uid, // UID from Firebase Authentication
          imageUrl: url,
          lastName: '',
          metadata: {
            'email' : email,
            'token' : token
          }
        ),
      );


      return Right(true);
    } on FirebaseAuthException catch(err){
      return Left(err.message!);
    }
  }


  static Future<Either<String,bool>> userLogin({
    required String email,
    required String password
  }) async {
    try{
     await FirebaseInstances.firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return Right(true);
    } on FirebaseAuthException catch(err){
      return Left(err.message!);
    }
  }

  static Future<Either<String,bool>> userLogOut() async {
    try{
       await FirebaseInstances.firebaseAuth.signOut();
      return Right(true);
    } on FirebaseAuthException catch(err){
      return Left(err.message!);
    }
  }

}