part of 'cubit.dart';

abstract class RealEstateListingsState {
  final List<RealEstateListing> listings;

  RealEstateListingsState(this.listings);
}

class GetAllRealEstateListingsInitial extends RealEstateListingsState {
  GetAllRealEstateListingsInitial() : super([]);
}

class GetAllRealEstateListingsLoading extends RealEstateListingsState {
  GetAllRealEstateListingsLoading(List<RealEstateListing> listings)
      : super(listings);
}

class GetAllRealEstateListingsSuccess extends RealEstateListingsState {
  GetAllRealEstateListingsSuccess(List<RealEstateListing> listings)
      : super(listings);
}

class GetAllRealEstateListingsFailure extends RealEstateListingsState {
  final String errorMessage;

  GetAllRealEstateListingsFailure(
      this.errorMessage, List<RealEstateListing> listings)
      : super(listings);
}

class PropertyDeletionLoading extends RealEstateListingsState {
  PropertyDeletionLoading(List<RealEstateListing> listings) : super(listings);
}

class PropertyDeletionSuccess extends RealEstateListingsState {
  final String message;
  PropertyDeletionSuccess(this.message, List<RealEstateListing> listings)
      : super(listings);
}

class PropertyDeletionFailure extends RealEstateListingsState {
  final String error;
  PropertyDeletionFailure(this.error, List<RealEstateListing> listings)
      : super(listings);
}

class UserProfileWithPropertyLoading extends RealEstateListingsState {
  UserProfileWithPropertyLoading(List<RealEstateListing> listings)
      : super(listings);
}

class UserProfileWithPropertySuccess extends RealEstateListingsState {
  final User user;
  UserProfileWithPropertySuccess(this.user, List<RealEstateListing> listings)
      : super(listings);
}

class UserProfileWithPropertyFailure extends RealEstateListingsState {
  final String message;
  UserProfileWithPropertyFailure(this.message, List<RealEstateListing> listings)
      : super(listings);
}
