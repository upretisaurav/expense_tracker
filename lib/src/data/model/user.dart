class User {
  final String id;
  final String name;
  final String profession;
  final String photo;

  User({
    required this.id,
    required this.name,
    required this.profession,
    required this.photo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profession: json['profession'] ?? '',
      photo: json['photo'] ?? '',
    );
  }
}
