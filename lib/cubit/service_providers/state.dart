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

class GetFilteredUsersInitial extends AllUsersState {}

class GetFilteredUsersLoading extends AllUsersState {}

class GetFilteredUsersSuccess extends AllUsersState {
  final List<User> filteredUsers;
  GetFilteredUsersSuccess(this.filteredUsers);
}

class GetFilteredUsersFailure extends AllUsersState {
  final String errorMessage;
  GetFilteredUsersFailure(this.errorMessage);
}
