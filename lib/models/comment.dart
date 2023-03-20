import 'package:flutter/material.dart';

class Comment{
  final String username;
  final String comment;
  final String imageUrl;
  final String uid;

  Comment({required this.username, required this.imageUrl, required this.comment, required this.uid});

  factory Comment.fromJson(Map<String,dynamic> json){
    return Comment(username: json['username'], imageUrl: json['imageUrl'], comment: json['comment'], uid: json['uid']);
  }

  Map<String, dynamic> toJson(){

    return{
      'comment' : this.comment,
      'imageUrl' : this.imageUrl,
      'username' : this.username,
      'uid' : this.uid
    };
  }



}