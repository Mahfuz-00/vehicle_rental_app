

import '../../../Domain/Entities/profile_entity.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Profile profile;

  ProfileLoaded(this.profile);
}

class ProfileLoggedOut extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}