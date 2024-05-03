// To parse this JSON data, do
//
//     final userScanned = userScannedFromJson(jsonString);

import 'dart:convert';

UserScanned userScannedFromJson(String str) =>
    UserScanned.fromJson(json.decode(str));

String userScannedToJson(UserScanned data) => json.encode(data.toJson());

class UserScanned {
  int id;
  String firstname;
  String lastname;
  String email;
  String phone;
  dynamic emailVerifiedAt;
  String role;
  String badgeToken;
  dynamic passwordResetToken;
  DateTime createdAt;
  DateTime updatedAt;

  UserScanned({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.emailVerifiedAt,
    required this.role,
    required this.badgeToken,
    required this.passwordResetToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserScanned.fromJson(Map<String, dynamic> json) => UserScanned(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        phone: json["phone"],
        emailVerifiedAt: json["email_verified_at"],
        role: json["role"],
        badgeToken: json["badgeToken"],
        passwordResetToken: json["password_reset_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phone": phone,
        "email_verified_at": emailVerifiedAt,
        "role": role,
        "badgeToken": badgeToken,
        "password_reset_token": passwordResetToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
