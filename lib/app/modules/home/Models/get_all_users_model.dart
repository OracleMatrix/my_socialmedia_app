import 'dart:convert';

List<GetAllUsersModel> getAllUsersModelFromJson(String str) =>
    List<GetAllUsersModel>.from(
      json.decode(str).map((x) => GetAllUsersModel.fromJson(x)),
    );

String getAllUsersModelToJson(List<GetAllUsersModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllUsersModel {
  int? id;
  String? name;
  String? email;
  DateTime? createdAt;
  DateTime? updatedAt;

  GetAllUsersModel({
    this.id,
    this.name,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory GetAllUsersModel.fromJson(
    Map<String, dynamic> json,
  ) => GetAllUsersModel(
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
