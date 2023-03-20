import 'comment.dart';





import 'like.dart';

class Post{
  final String id;
  final String title;
  final String imageUrl;
  final String detail;
  final String userId;
  final Like likes;
  final List<Comment> comment;
  final String imageId;

  Post({ required this.imageId, required this.imageUrl, required this.id, required this.likes, required this.title, required this.detail, required this.userId, required this.comment});


}