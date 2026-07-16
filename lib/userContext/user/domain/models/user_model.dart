import 'package:medquest/auth/domain/models/auth_entities.dart';

class UserModel extends User {
  const UserModel({
    required super.uid,
    required super.name,
    required super.email,
  });


  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }
}