import 'dart:convert';

UserDataModel userDataModelFromJson(String str) =>
    UserDataModel.fromJson(json.decode(str));

String userDataModelToJson(UserDataModel data) => json.encode(data.toJson());

class UserDataModel {
  int? id;
  String? name;
  String? email;
  String? profilePicture;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Post>? posts;
  List<Follow>? follower;
  List<Follow>? following;

  UserDataModel({
    this.id,
    this.name,
    this.email,
    this.profilePicture,
    this.createdAt,
    this.updatedAt,
    this.posts,
    this.follower,
    this.following,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    profilePicture: json["profilePicture"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    posts:
        json["posts"] == null
            ? []
            : List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
    follower:
        json["follower"] == null
            ? []
            : List<Follow>.from(
              json["follower"].map((x) => Follow.fromJson(x)),
            ),
    following:
        json["following"] == null
            ? []
            : List<Follow>.from(
              json["following"].map((x) => Follow.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "profilePicture": profilePicture,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "posts":
        posts == null ? [] : List<dynamic>.from(posts!.map((x) => x.toJson())),
    "follower":
        follower == null
            ? []
            : List<dynamic>.from(follower!.map((x) => x.toJson())),
    "following":
        following == null
            ? []
            : List<dynamic>.from(following!.map((x) => x.toJson())),
  };
}

class Follow {
  int? id;
  int? followerId;
  int? followingId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Follower? following;
  Follower? follower;

  Follow({
    this.id,
    this.followerId,
    this.followingId,
    this.createdAt,
    this.updatedAt,
    this.following,
    this.follower,
  });

  factory Follow.fromJson(Map<String, dynamic> json) => Follow(
    id: json["id"],
    followerId: json["followerId"],
    followingId: json["followingId"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    following:
        json["following"] == null ? null : Follower.fromJson(json["following"]),
    follower:
        json["follower"] == null ? null : Follower.fromJson(json["follower"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "followerId": followerId,
    "followingId": followingId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "following": following?.toJson(),
    "follower": follower?.toJson(),
  };
}

class Follower {
  int? id;
  String? name;
  String? email;
  DateTime? createdAt;
  DateTime? updatedAt;

  Follower({this.id, this.name, this.email, this.createdAt, this.updatedAt});

  factory Follower.fromJson(Map<String, dynamic> json) => Follower(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class Post {
  int? id;
  String? title;
  String? content;
  String? postPicture;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Comment>? comments;
  List<Comment>? likes;

  Post({
    this.id,
    this.title,
    this.content,
    this.postPicture,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.comments,
    this.likes,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    postPicture: json["postPicture"],
    userId: json["userId"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    comments:
        json["comments"] == null
            ? []
            : List<Comment>.from(
              json["comments"].map((x) => Comment.fromJson(x)),
            ),
    likes:
        json["likes"] == null
            ? []
            : List<Comment>.from(json["likes"].map((x) => Comment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "content": content,
    "postPicture": postPicture,
    "userId": userId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
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
  int? userId;
  int? postId;
  String? content;
  DateTime? createdAt;
  DateTime? updatedAt;
  Follower? user;

  Comment({
    this.id,
    this.userId,
    this.postId,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    userId: json["userId"],
    postId: json["postId"],
    content: json["content"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    user: json["user"] == null ? null : Follower.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "postId": postId,
    "content": content,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "user": user?.toJson(),
  };
}
