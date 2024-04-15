// To parse this JSON data, do
//
//     final eventModel = eventModelFromJson(jsonString);

import 'dart:convert';

EventModel eventModelFromJson(String str) =>
    EventModel.fromJson(json.decode(str));

String eventModelToJson(EventModel data) => json.encode(data.toJson());

class EventModel {
  int id;
  String titre;
  String description;
  String image;
  DateTime date;
  String heure;
  String lieu;
  int prix;
  int status;
  int limitBillets;
  int billetsVendus;
  DateTime createdAt;
  DateTime updatedAt;
  int userId;

  EventModel({
    required this.id,
    required this.titre,
    required this.description,
    required this.image,
    required this.date,
    required this.heure,
    required this.lieu,
    required this.prix,
    required this.status,
    required this.limitBillets,
    required this.billetsVendus,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json["id"],
        titre: json["titre"],
        description: json["description"],
        image: json["image"],
        date: DateTime.parse(json["date"]),
        heure: json["heure"],
        lieu: json["lieu"],
        prix: json["prix"],
        status: json["status"],
        limitBillets: json["limitBillets"],
        billetsVendus: json["billetsVendus"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "titre": titre,
        "description": description,
        "image": image,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "heure": heure,
        "lieu": lieu,
        "prix": prix,
        "status": status,
        "limitBillets": limitBillets,
        "billetsVendus": billetsVendus,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user_id": userId,
      };
}
