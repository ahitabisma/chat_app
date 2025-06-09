class User {
  final int id;
  final String name;
  final String email;
  final String photo;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.photo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      photo: json['photo'] as String,
    );
  }
}
