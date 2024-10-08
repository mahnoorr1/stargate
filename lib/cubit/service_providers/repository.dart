part of 'cubit.dart';

class UserRepository {
  final UserDataProvider _userDataProvider = UserDataProvider();

  UserRepository();

  Future<List<User>> getAllUsers() async {
    try {
      return await _userDataProvider.getAllUsers();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<User>> filterUsers({
    String? country,
    String? city,
    String? experience,
  }) async {
    try {
      return await _userDataProvider.filterUsers(
        country: country,
        city: city,
        experience: experience,
      );
    } catch (e) {
      rethrow;
    }
  }
}
