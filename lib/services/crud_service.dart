
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_2/common/firebase_instances.dart';
import 'package:flutter_app_2/models/comment.dart';
import 'package:flutter_app_2/models/like.dart';
import 'package:flutter_app_2/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:image_picker/image_picker.dart';

final moviePostStreamProvider = StreamProvider((ref) => CrudService.getMoviePosts());

class CrudService{

  static CollectionReference moviePostCollection = FirebaseInstances.firebaseFirestore.collection('moviePosts');


  static Stream<List<Post>> getMoviePosts(){
    return moviePostCollection.snapshots().map((event) => getSome(event));

  }

  static List<Post> getSome(QuerySnapshot querySnapshot){
    return querySnapshot.docs.map((e) {
      final post = e.data() as Map<String,dynamic> ;
      return Post(imageUrl: post['imageUrl'], imageId: post['imageId'],id: e.id
          , likes: Like.fromJson(post['like']), title: post['title'], detail: post['detail'], userId: post['userId'],
          comment: (post['comment'] as List).map((element) => Comment.fromJson(element)).toList()

      );}).toList();

  }


  static Future<Either<String,bool>> addPost({
    required String title,
    required String detail,
    required String userId,
    required XFile image
  }) async {
    try{
      final imageId = DateTime.now().toString();
      final ref = FirebaseInstances.firebaseStorage.ref().child('moviePostImage/$imageId');
      await ref.putFile(File(image.path));
      final imageUrl = await ref.getDownloadURL();
      await moviePostCollection.add({
        'title' : title,
        'detail' : detail,
        'imageId' : imageId,
        'imageUrl' : imageUrl,
        'userId' : userId,
        'comment' : [],
        'like' : {
          'likes' : 0,
          'usernames' : [],
          'toggleLike' : false
        }
      }).then((value) => print('Post Created with ID: ${value.id}')).catchError((error) => print('Post not created because of this error: $error'));
      return Right(true);
    } on FirebaseException catch(err){
      return Left(err.message!);
    }
  }

  static Future<Either<String,bool>> updatePost({
    required String title,
    required String detail,
    required String postId,
    required XFile? image,
    required String? oldImageId
  }) async {
    try{
      if(image == null){
        await moviePostCollection.doc(postId).update({
          'title' : title,
          'detail' : detail,
        });
      }else{

        final ref = FirebaseInstances.firebaseStorage.ref().child('moviePostImage/$oldImageId');
        await ref.delete();
        final newImageId = DateTime.now().toString();
        final newRef = FirebaseInstances.firebaseStorage.ref().child('moviePostImage/$newImageId');
        await newRef.putFile(File(image.path));
        final imageUrl = await newRef.getDownloadURL();
        await moviePostCollection.doc(postId).update({
          'title' : title,
          'detail' : detail,
          'imageUrl' : imageUrl,
          'imageId' : newImageId
        });

      }
      return Right(true);
    } on FirebaseException catch(err){
      return Left(err.message!);
    }
  }

  static Future<Either<String,bool>> deletePost({
    required String postId,
    required String imageId,
  }) async {
    try{
      final ref = FirebaseInstances.firebaseStorage.ref().child('moviePostImage/$imageId');
      await ref.delete();
      await moviePostCollection.doc(postId).delete();
      return Right(true);
    } on FirebaseException catch(err){
      return Left(err.message!);
    }
  }

  static Future<Either<String,bool>> addLike({
    required List<String> usernames,
    required int like,
    required String postId,
  }) async {
    try{
      await moviePostCollection.doc(postId).update({
      'like' : {
      'likes' : like + 1,
      'usernames' : FieldValue.arrayUnion(usernames),
        'toggleLike' : true
      }
      });
      return Right(true);
    } on FirebaseException catch(err){
      return Left(err.message!);
    }
  }

  static Future<Either<String,bool>> disLike({
    required List<String> usernames,
    required int like,
    required String postId,
  }) async {
    try{
      await moviePostCollection.doc(postId).update({
        'like' : {
          'likes' : like - 1,
          'usernames' : FieldValue.arrayRemove(usernames),
          'toggleLike' : false
        }
      });
      return Right(true);
    } on FirebaseException catch(err){
      return Left(err.message!);
    }
  }

  static Future<Either<String,bool>> addComment({
    required List<Comment> comments,
    required String postId,
  }) async {
    try{
      await moviePostCollection.doc(postId).update({
        'comment' : comments.map((e) => e.toJson()).toList()
      });
      return Right(true);
    } on FirebaseException catch(err){
      return Left(err.message!);
    }
  }


}