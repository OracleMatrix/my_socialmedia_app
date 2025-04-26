import 'dart:convert';

List<GetUserByEmailModel> getUserByEmailModelFromJson(String str) =>
    List<GetUserByEmailModel>.from(
      json.decode(str).map((x) => GetUserByEmailModel.fromJson(x)),
    );

String getUserByEmailModelToJson(List<GetUserByEmailModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetUserByEmailModel {
  int? id;
  String? name;
  String? email;
  DateTime? createdAt;
  DateTime? updatedAt;

  GetUserByEmailModel({
    this.id,
    this.name,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory GetUserByEmailModel.fromJson(
    Map<String, dynamic> json,
  ) => GetUserByEmailModel(
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
