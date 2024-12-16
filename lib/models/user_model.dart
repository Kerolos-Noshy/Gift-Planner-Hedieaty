class User {
  String id;
  String name;
  String phone;
  String email;
  String gender;
  String? preferences;


  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.gender,
    this.preferences,
  });

  factory User.fromMap(Map<String, dynamic> map) => User(
    id: map['id'],
    name: map['name'],
    phone: map['phone'],
    email: map['email'],
    gender: map['gender'],
    preferences: map['preferences'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'gender': gender,
    'preferences': preferences,
  };
}
