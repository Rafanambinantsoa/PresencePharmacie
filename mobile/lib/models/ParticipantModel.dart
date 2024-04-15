// To parse this JSON data, do
//
//     final participantModel = participantModelFromJson(jsonString);

import 'dart:convert';

ParticipantModel participantModelFromJson(String str) =>
    ParticipantModel.fromJson(json.decode(str));

String participantModelToJson(ParticipantModel data) =>
    json.encode(data.toJson());

class ParticipantModel {
  String nom;
  String email;
  int isScanned;

  ParticipantModel({
    required this.nom,
    required this.email,
    required this.isScanned,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) =>
      ParticipantModel(
        nom: json["nom"],
        email: json["email"],
        isScanned: json["isScanned"],
      );

  Map<String, dynamic> toJson() => {
        "nom": nom,
        "email": email,
        "isScanned": isScanned,
      };
}
