part of 'cubit.dart';

class RealEstateDataProvider {
  Future<List<RealEstateListing>> getAllRealEstateListings() async {
    try {
      Future<List<RealEstateListing>> listings = getAllListings();
      return listings;
    } catch (e) {
      throw Exception('Failed to get real estate listings: ${e.toString()}');
    }
  }

  Future<String> deleteListing(String id) async {
    try {
      Future<String> delete = deleteProperty(id: id);
      return delete;
    } catch (e) {
      throw Exception("Deletion failed");
    }
  }

  Future<User> getUserProfileAlongWithProperty() async {
    try {
      User? getUser = await myProfile();
      return getUser!;
    } catch (e) {
      throw Exception("Unable to get User Details");
    }
  }
}
