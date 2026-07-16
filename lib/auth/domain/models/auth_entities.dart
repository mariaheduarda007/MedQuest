import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String name;
  final String email;

  const User({
    required this.uid,
    required this.name,
    required this.email,
  });

  User copyWith({
    String? uid,
    String? name,
    String? email,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [uid, name, email];

  @override
  String toString() => 'User(uid: $uid, name: $name, email: $email)';
}

class Token extends Equatable {
  final String value;
  final DateTime expiresAt;

  const Token({
    required this.value,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  @override
  List<Object?> get props => [value, expiresAt];
}

class AuthSession extends Equatable {
  final User user;
  final Token token;

  const AuthSession({
    required this.user,
    required this.token,
  });

  bool get isValid => !token.isExpired;

  @override
  List<Object?> get props => [user, token];
}