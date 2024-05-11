import 'user.dart';

class Post {
  int? id;
  String? header;
  String? subheader;
  String? body;
  String? image;
  int? likesCount;
  int? commentsCount;
  User? user;
  bool? selfLiked;

  Post({
    this.id,
    this.header,
    this.subheader,
    this.body,
    this.image,
    this.likesCount,
    this.commentsCount,
    this.user,
    this.selfLiked,
  });

// map json to post model

factory Post.fromJson(Map<String, dynamic> json) {
  return Post(
    id: json['id'],
    header: json['header'],
    subheader: json['subheader'],
    body: json['body'],
    image: json['image'],
    likesCount: json['likes_count'],
    commentsCount: json['comments_count'],
    selfLiked: json['likes'].length > 0,
    user: User(
      id: json['user']['id'],
      name: json['user']['name'],
      image: json['user']['image']
    )
  );
}

}