part of 'cubit.dart';

class UserDataProvider {
  Future<List<User>> getAllUsers() async {
    try {
      Future<List<User>> users = getAllServiceUsers();
      return users;
    } catch (e) {
      throw Exception('Failed to get users: ${e.toString()}');
    }
  }
}
