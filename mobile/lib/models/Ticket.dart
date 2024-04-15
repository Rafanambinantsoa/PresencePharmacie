class Ticket {
  int? id;
  String? title;
  int? isScanned;
  int? prix;
  int? eventId;

// Constructor
  Ticket({this.id, this.title, this.isScanned, this.prix, this.eventId});

  // funciton to convert json to object or user model
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['ticket']['id'],
      title: json['ticket']['title'],
      isScanned: json['ticket']['isScanned'],
      prix: json['ticket']['prix'],
      eventId: json['ticket']['eventId'],
    );
  }
  String get scannedStatus {
    return isScanned == 0
        ? "Billet non scanné, accès autorisé"
        : "Billet déjà scanné, accès refusé.";
  }
}
