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

  Future<List<User>> filterUsers({
    String? country,
    String? city,
    String? experience,
  }) async {
    try {
      Future<List<User>> users = filterServiceUsers(
        country: country,
        city: city,
        experience: experience,
      );
      return users;
    } catch (e) {
      throw Exception('Failed to get users: ${e.toString()}');
    }
  }
}
