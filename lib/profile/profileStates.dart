import 'package:parking_4/profile/profile_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;
  UserLoaded(this.user);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

class UserUpstaeLoading extends UserState {}

class UserUpdateLoaded extends UserState {
  final UserModel user;
  UserUpdateLoaded(this.user);
}

class UserDeleted extends UserState {}

class UpdateFaild extends UserState {
  final String message;
  UpdateFaild(this.message);
}
