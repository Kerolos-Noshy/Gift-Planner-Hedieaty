class User {
  int? id;
  String name;
  String email;
  String? preferences;
  String gender;
  String? profileImagePath;

  User({this.id, required this.name, required this.email, this.preferences, required this.gender, this.profileImagePath,});

  factory User.fromMap(Map<String, dynamic> map) => User(
    id: map['id'],
    name: map['name'],
    email: map['email'],
    preferences: map['preferences'],
    gender: map['gender'],
    profileImagePath: map['profile_image_path'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'preferences': preferences,
    'gender': gender,
    'profile_image_path': profileImagePath,
  };
}
