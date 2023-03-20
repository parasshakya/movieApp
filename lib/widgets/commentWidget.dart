import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {

  final String commenterName;
  final String commenterProfilePicUrl;
  final String commentText;


  CommentWidget({
    required this.commenterName,
    required this.commenterProfilePicUrl,
    required this.commentText,

  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(commenterProfilePicUrl),
      ),
      title: Text(commenterName),
      subtitle: Text(commentText),
    );
  }
}
