part of './cubit.dart';

sealed class AllUsersState {}

class GetAllUsersInitial extends AllUsersState {}

class GetAllUsersLoading extends AllUsersState {}

class GetAllUsersSuccess extends AllUsersState {
  final List<User> users;

  GetAllUsersSuccess(this.users);
}

class GetAllUsersFailure extends AllUsersState {
  final String errorMessage;

  GetAllUsersFailure(this.errorMessage);
}
