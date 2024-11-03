import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stargate/models/user.dart';
import 'package:stargate/services/service_providers.dart';

part './state.dart';
part './data_provider.dart';
part './repository.dart';

class AllUsersCubit extends Cubit<AllUsersState> {
  final UserRepository userRepository = UserRepository();

  AllUsersCubit() : super(GetAllUsersInitial());

  Future<void> getAllUsers() async {
    try {
      emit(GetAllUsersLoading());
      List<User> users = await userRepository.getAllUsers();
      emit(GetAllUsersSuccess(users));
    } catch (e) {
      emit(GetAllUsersFailure(e.toString()));
    }
  }

  Future<void> filterUsers({
    String? country,
    String? city,
    String? experience,
  }) async {
    try {
      emit(GetFilteredUsersLoading());
      List<User> users = await userRepository.filterUsers(
        country: country,
        city: city,
        experience: experience,
      );
      emit(GetFilteredUsersSuccess(users));
    } catch (e) {
      emit(GetFilteredUsersFailure(e.toString()));
    }
  }
}
