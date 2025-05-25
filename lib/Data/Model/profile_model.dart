import '../../Domain/Entities/profile_entity.dart';

class ProfileModel {
  final String name;
  final String email;
  final int totalTrips;

  ProfileModel({
    required this.name,
    required this.email,
    required this.totalTrips,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] as String,
      email: json['email'] as String,
      totalTrips: json['total_trips'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'total_trips': totalTrips,
    };
  }

  Profile toEntity() {
    return Profile(
      name: name,
      email: email,
      totalTrips: totalTrips,
    );
  }

  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      name: profile.name,
      email: profile.email,
      totalTrips: profile.totalTrips,
    );
  }
}