import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stargate/models/real_estate_listing.dart';
import 'package:stargate/services/real_estate_listings.dart';
import 'package:stargate/services/user_profiling.dart';

import '../../models/profile.dart';
part './state.dart';
part './data_provider.dart';

class RealEstateListingsCubit extends Cubit<RealEstateListingsState> {
  RealEstateListingsCubit() : super(GetAllRealEstateListingsInitial());

  final dataProvider = RealEstateDataProvider();
  Future<void> getAllRealEstateListings() async {
    try {
      emit(GetAllRealEstateListingsLoading());
      List<RealEstateListing> listings =
          await dataProvider.getAllRealEstateListings();
      emit(GetAllRealEstateListingsSuccess(listings));
    } catch (e) {
      emit(GetAllRealEstateListingsFailure(e.toString()));
    }
  }

  Future<void> deleteListing(String id) async {
    try {
      emit(PropertyDeletionLoading());
      String deletion = await dataProvider.deleteListing(id);
      emit(PropertyDeletionSuccess(deletion));
      getUserProfileAlongWithProperty();
    } catch (e) {
      emit(PropertyDeletionFailure(e.toString()));
    }
  }

  Future<void> getUserProfileAlongWithProperty() async {
    try {
      emit(UserProfileWithPropertyLoading());
      User user = await dataProvider.getUserProfileAlongWithProperty();
      emit(UserProfileWithPropertySuccess(user));
    } catch (e) {
      emit(UserProfileWithPropertyFailure(e.toString()));
    }
  }
}
