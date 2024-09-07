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
}
