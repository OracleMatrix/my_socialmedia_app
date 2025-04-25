import 'dart:convert';

UserDataModel userDataModelFromJson(String str) =>
    UserDataModel.fromJson(json.decode(str));

String userDataModelToJson(UserDataModel data) => json.encode(data.toJson());

class UserDataModel {
  int? id;
  String? name;
  String? email;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Post>? posts;
  List<Follower>? follower;
  List<dynamic>? following;

  UserDataModel({
    this.id,
    this.name,
    this.email,
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
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    posts:
        json["posts"] == null
            ? []
            : List<Post>.from(json["posts"]!.map((x) => Post.fromJson(x))),
    follower:
        json["follower"] == null
            ? []
            : List<Follower>.from(
              json["follower"]!.map((x) => Follower.fromJson(x)),
            ),
    following:
        json["following"] == null
            ? []
            : List<dynamic>.from(json["following"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "posts":
        posts == null ? [] : List<dynamic>.from(posts!.map((x) => x.toJson())),
    "follower":
        follower == null
            ? []
            : List<dynamic>.from(follower!.map((x) => x.toJson())),
    "following":
        following == null ? [] : List<dynamic>.from(following!.map((x) => x)),
  };
}

class Follower {
  int? id;
  int? followerId;
  int? followingId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Following? following;

  Follower({
    this.id,
    this.followerId,
    this.followingId,
    this.createdAt,
    this.updatedAt,
    this.following,
  });

  factory Follower.fromJson(Map<String, dynamic> json) => Follower(
    id: json["id"],
    followerId: json["followerId"],
    followingId: json["followingId"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    following:
        json["following"] == null
            ? null
            : Following.fromJson(json["following"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "followerId": followerId,
    "followingId": followingId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "following": following?.toJson(),
  };
}

class Following {
  int? id;
  String? name;
  String? email;
  DateTime? createdAt;
  DateTime? updatedAt;

  Following({this.id, this.name, this.email, this.createdAt, this.updatedAt});

  factory Following.fromJson(Map<String, dynamic> json) => Following(
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
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? comments;
  List<dynamic>? likes;

  Post({
    this.id,
    this.title,
    this.content,
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
    userId: json["userId"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    comments:
        json["comments"] == null
            ? []
            : List<dynamic>.from(json["comments"]!.map((x) => x)),
    likes:
        json["likes"] == null
            ? []
            : List<dynamic>.from(json["likes"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "content": content,
    "userId": userId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "comments":
        comments == null ? [] : List<dynamic>.from(comments!.map((x) => x)),
    "likes": likes == null ? [] : List<dynamic>.from(likes!.map((x) => x)),
  };
}
