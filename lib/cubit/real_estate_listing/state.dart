part of 'cubit.dart';

sealed class RealEstateListingsState {}

class GetAllRealEstateListingsInitial extends RealEstateListingsState {}

class GetAllRealEstateListingsLoading extends RealEstateListingsState {}

class GetAllRealEstateListingsSuccess extends RealEstateListingsState {
  final List<RealEstateListing> listings;

  GetAllRealEstateListingsSuccess(this.listings);
}

class GetAllRealEstateListingsFailure extends RealEstateListingsState {
  final String errorMessage;

  GetAllRealEstateListingsFailure(this.errorMessage);
}

class PropertyDeletionInitial extends RealEstateListingsState {}

class PropertyDeletionLoading extends RealEstateListingsState {}

class PropertyDeletionSuccess extends RealEstateListingsState {
  final String message;
  PropertyDeletionSuccess(this.message);
}

class PropertyDeletionFailure extends RealEstateListingsState {
  final String error;
  PropertyDeletionFailure(this.error);
}

class UserProfileWithPropertyInitial extends RealEstateListingsState {}

class UserProfileWithPropertyLoading extends RealEstateListingsState {}

class UserProfileWithPropertySuccess extends RealEstateListingsState {
  final User user;
  UserProfileWithPropertySuccess(this.user);
}

class UserProfileWithPropertyFailure extends RealEstateListingsState {
  final String message;
  UserProfileWithPropertyFailure(this.message);
}
