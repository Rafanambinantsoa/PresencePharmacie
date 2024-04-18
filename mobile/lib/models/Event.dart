// To parse this JSON data, do
//
//     final eventModel = eventModelFromJson(jsonString);

import 'dart:convert';

List<EventModel> eventModelFromJson(String str) =>
    List<EventModel>.from(json.decode(str).map((x) => EventModel.fromJson(x)));

String eventModelToJson(List<EventModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EventModel {
  int id;
  String titre;
  String description;
  DateTime date;
  Heure heure;
  String lieu;
  DateTime createdAt;
  DateTime updatedAt;
  int userId;

  EventModel({
    required this.id,
    required this.titre,
    required this.description,
    required this.date,
    required this.heure,
    required this.lieu,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json["id"],
        titre: json["titre"],
        description: json["description"],
        date: DateTime.parse(json["date"]),
        heure: heureValues.map[json["heure"]]!,
        lieu: json["lieu"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "titre": titre,
        "description": description,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "heure": heureValues.reverse[heure],
        "lieu": lieu,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user_id": userId,
      };
}

enum Heure { THE_1200, THE_1402 }

final heureValues =
    EnumValues({"12:00": Heure.THE_1200, "14:02": Heure.THE_1402});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
