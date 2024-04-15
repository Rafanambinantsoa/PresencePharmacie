class Scan {
  String? message;

// Constructor
  Scan({this.message});

  // funciton to convert json to object or user model
  factory Scan.fromJson(Map<String, dynamic> json) {
    return Scan(
      message: json['message'],
    );
  }
}
