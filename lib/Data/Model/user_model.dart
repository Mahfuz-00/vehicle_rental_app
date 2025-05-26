import '../../Domain/Entities/user_entity.dart';

class UserModel {
  final String token;
  final String id;
  final String name;
  final String email;

  UserModel({
    required this.token,
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] as String,
      id: json['user']['id'] as String,
      name: json['user']['name'] as String,
      email: json['user']['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': {
        'id': id,
        'name': name,
        'email': email,
      },
    };
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
    );
  }

  factory UserModel.fromEntity(User user, String token) {
    return UserModel(
      token: token,
      id: user.id,
      name: user.name,
      email: user.email,
    );
  }
}