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

  // Store current listings to manage dynamic updates
  List<RealEstateListing> currentListings = [];

  Future<void> getAllRealEstateListings() async {
    try {
      emit(GetAllRealEstateListingsLoading(currentListings));
      List<RealEstateListing> newListings =
          await dataProvider.getAllRealEstateListings();

      // Update the current listings
      currentListings = newListings;
      emit(GetAllRealEstateListingsSuccess(currentListings));
    } catch (e) {
      emit(GetAllRealEstateListingsFailure(e.toString(), currentListings));
    }
  }

  Future<void> deleteListing(String id) async {
    try {
      emit(PropertyDeletionLoading(currentListings));
      String deletion = await dataProvider.deleteListing(id);

      // Remove the deleted property from the current listings
      currentListings.removeWhere((listing) => listing.id == id);
      emit(PropertyDeletionSuccess(deletion, currentListings));
    } catch (e) {
      emit(PropertyDeletionFailure(e.toString(), currentListings));
    }
  }

  Future<void> getUserProfileAlongWithProperty() async {
    try {
      emit(UserProfileWithPropertyLoading(currentListings));
      User user = await dataProvider.getUserProfileAlongWithProperty();
      emit(UserProfileWithPropertySuccess(user, currentListings));
    } catch (e) {
      emit(UserProfileWithPropertyFailure(e.toString(), currentListings));
    }
  }
}
