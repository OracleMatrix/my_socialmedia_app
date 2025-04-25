// ignore_for_file: unnecessary_null_checks

import 'dart:convert';

GetAllPosts getAllPostsFromJson(String str) =>
    GetAllPosts.fromJson(json.decode(str));

String getAllPostsToJson(GetAllPosts data) => json.encode(data.toJson());

class GetAllPosts {
  String? message;
  int? totalPosts;
  List<Post>? posts;

  GetAllPosts({this.message, this.totalPosts, this.posts});

  factory GetAllPosts.fromJson(Map<String, dynamic> json) => GetAllPosts(
    message: json["message"],
    totalPosts: json["totalPosts"],
    posts:
        json["posts"] == null
            ? []
            : List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "totalPosts": totalPosts,
    "posts":
        posts == null ? [] : List<dynamic>.from(posts!.map((x) => x.toJson())),
  };
}

class Post {
  int? id;
  String? title;
  String? content;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;
  List<Comment>? comments;
  List<Like>? likes;

  Post({
    this.id,
    this.title,
    this.content,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.comments,
    this.likes,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    userId: json["userId"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    comments:
        json["comments"] == null
            ? []
            : List<Comment>.from(
              json["comments"].map((x) => Comment.fromJson(x)),
            ),
    likes:
        json["likes"] == null
            ? []
            : List<Like>.from(json["likes"].map((x) => Like.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "content": content,
    "userId": userId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "user": user?.toJson(),
    "comments":
        comments == null
            ? []
            : List<dynamic>.from(comments!.map((x) => x.toJson())),
    "likes":
        likes == null ? [] : List<dynamic>.from(likes!.map((x) => x.toJson())),
  };
}

class Comment {
  int? id;
  String? content;
  User? user;

  Comment({this.id, this.content, this.user});

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    content: json["content"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "content": content,
    "user": user?.toJson(),
  };
}

class Like {
  int? id;
  User? user;

  Like({this.id, this.user});

  factory Like.fromJson(Map<String, dynamic> json) => Like(
    id: json["id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {"id": id, "user": user?.toJson()};
}

class User {
  int? id;
  String? name;
  String? email;

  User({this.id, this.name, this.email});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json["id"], name: json["name"], email: json["email"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "email": email};
}
