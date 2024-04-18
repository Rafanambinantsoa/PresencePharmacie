// To parse this JSON data, do
//
//     final notifScan = notifScanFromJson(jsonString);

import 'dart:convert';

NotifScan notifScanFromJson(String str) => NotifScan.fromJson(json.decode(str));

String notifScanToJson(NotifScan data) => json.encode(data.toJson());

class NotifScan {
  String message;

  NotifScan({
    required this.message,
  });

  factory NotifScan.fromJson(Map<String, dynamic> json) => NotifScan(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
