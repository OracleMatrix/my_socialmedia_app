import 'dart:convert';

GetAllPostsModel getAllPostsModelFromJson(String str) =>
    GetAllPostsModel.fromJson(json.decode(str));

String getAllPostsModelToJson(GetAllPostsModel data) =>
    json.encode(data.toJson());

class GetAllPostsModel {
  String? message;
  int? totalPosts;
  List<Post>? posts;

  GetAllPostsModel({this.message, this.totalPosts, this.posts});

  factory GetAllPostsModel.fromJson(Map<String, dynamic> json) =>
      GetAllPostsModel(
        message: json["message"],
        totalPosts: json["totalPosts"],
        posts:
            json["posts"] == null
                ? []
                : List<Post>.from(json["posts"]!.map((x) => Post.fromJson(x))),
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
              json["comments"]!.map((x) => Comment.fromJson(x)),
            ),
    likes:
        json["likes"] == null
            ? []
            : List<Like>.from(json["likes"]!.map((x) => Like.fromJson(x))),
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

class User {
  int? id;
  String? name;
  String? email;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Following>? following;

  User({
    this.id,
    this.name,
    this.email,
    this.createdAt,
    this.updatedAt,
    this.following,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    following:
        json["following"] == null
            ? []
            : List<Following>.from(
              json["following"]!.map((x) => Following.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "following":
        following == null
            ? []
            : List<dynamic>.from(following!.map((x) => x.toJson())),
  };
}

class Following {
  int? id;
  int? followerId;
  int? followingId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Following({
    this.id,
    this.followerId,
    this.followingId,
    this.createdAt,
    this.updatedAt,
  });

  factory Following.fromJson(Map<String, dynamic> json) => Following(
    id: json["id"],
    followerId: json["followerId"],
    followingId: json["followingId"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "followerId": followerId,
    "followingId": followingId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
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
