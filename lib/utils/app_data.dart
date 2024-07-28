import 'package:stargate/models/real_estate_listing.dart';
import 'package:stargate/models/user.dart';
import 'package:stargate/utils/app_enums.dart';

List<User> users = [
  User(
    name: 'John Doe',
    image:
        'https://images.stockcake.com/public/0/3/1/0316b537-d898-429c-8d78-099e7df7a140_large/masked-urban-individual-stockcake.jpg',
    services: [
      Service(userType: UserType.investor, experience: 5),
      Service(userType: UserType.agent, experience: 3),
    ],
    address: 'HNO 654, street 2, West, Green Garden, Abogado',
    city: 'Anytown',
    country: 'USA',
  ),
  User(
    name: 'Hashim',
    image:
        'https://images.stockcake.com/public/0/3/1/0316b537-d898-429c-8d78-099e7df7a140_large/masked-urban-individual-stockcake.jpg',
    services: [
      Service(
          userType: UserType.lawyer,
          experience: 4,
          serviceSubcategory: "law enforcement"),
      Service(userType: UserType.notary, experience: 3),
    ],
    address: '123 Main St',
    city: 'Anytown',
    country: 'USA',
  ),
];

List<RealEstateListing> listings = [
  RealEstateListing(
    title: "Central House",
    address: "Hno 786, street 67 north, wesex",
    price: 180000,
    country: "Germany",
    city: "City",
    state: "District",
    description:
        "The house is fully furnished and newly constructed contains all the facilities and a 10/10 in condition, interested person can contact at my given contact information.",
    requestType: "request",
    condition: "new",
    propertyType: "commercial",
    propertyCategory: "Bangalow",
    propertySubCategory: "Royal Bangalow",
    sellingType: "rental",
    noOfBeds: 8,
    noOfBathrooms: 8,
    pictures: [
      'https://images.stockcake.com/public/f/7/0/f7005cd1-6c21-4903-b28c-fbf3537c241e/luxury-estate-elegance-stockcake.jpg',
      'https://images.stockcake.com/public/d/0/b/d0bc6c18-9f1a-46c9-aa01-3c8aa6855e09_large/luxurious-mansion-exterior-stockcake.jpg',
    ],
    furnished: true,
    garage: true,
    landAreaInTotal: 2400,
    occupiedLandArea: 1200,
  ),
  RealEstateListing(
    title: "The Pearls",
    address: "Hno 786, street 67 north, wesex",
    price: 280000,
    country: "Germany",
    city: "City",
    state: "District",
    description:
        "The house is fully furnished and newly constructed contains all the facilities and a 10/10 in condition, interested person can contact at my given contact information.",
    requestType: "request",
    condition: "renovating",
    propertyType: "commercial",
    propertyCategory: "Bangalow",
    propertySubCategory: "Royal Bangalow",
    sellingType: "rental",
    noOfBeds: 8,
    noOfBathrooms: 8,
    pictures: [
      'https://images.stockcake.com/public/f/7/0/f7005cd1-6c21-4903-b28c-fbf3537c241e/luxury-estate-elegance-stockcake.jpg',
      'https://images.stockcake.com/public/d/0/b/d0bc6c18-9f1a-46c9-aa01-3c8aa6855e09_large/luxurious-mansion-exterior-stockcake.jpg',
    ],
    furnished: false,
    garage: false,
    landAreaInTotal: 2400,
    occupiedLandArea: 1200,
  ),
];

List<String> propertyTypes = ['commercial', 'conventional'];
List<String> sellingTypes = ['purchase', 'rental'];
List<String> conditions = ['new', 'old', 'renovating'];
List<String> requestType = ['offer', 'request'];
List<String> commercialPropertyCategory = ['Hotel'];
List<String> conventionalPropertyCategory = ['Rental Building'];
List<String> commercialPropertySubcategory = ['Town House'];
List<String> conventionalPropertySubcategory = ['Small House'];
