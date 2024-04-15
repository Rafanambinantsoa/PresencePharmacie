class User {
  int? id;
  String? name;
  String? email;
  String? token;

// Constructor
  User({this.id, this.name, this.email, this.token});

  // funciton to convert json to object or user model
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'],
      name: json['user']['name'],
      email: json['user']['email'],
      token: json['token'],
    );
  }
}
