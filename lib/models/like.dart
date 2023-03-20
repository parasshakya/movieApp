class Like{
  final int likes;
  final List<String> usernames;
  final bool toggleLike;
  Like({required this.likes, required this.usernames, required this.toggleLike});


factory Like.fromJson(Map<String,dynamic> json){
  return Like(likes: json['likes'],
      usernames: (json['usernames'] as List).map((e) => e as String).toList(),
  toggleLike: json['toggleLike']);
}

}

