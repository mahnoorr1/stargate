import 'package:stargate/localization/translation_strings.dart';
import 'package:stargate/models/faq.dart';
import 'package:stargate/models/user.dart';
import 'package:stargate/utils/app_enums.dart';
import 'package:translator/translator.dart';

List<User> users = [
  // User(
  //   name: 'Syeda Mahnoor Hashmi',
  //   image:
  //       'https://images.stockcake.com/public/0/3/1/0316b537-d898-429c-8d78-099e7df7a140_large/masked-urban-individual-stockcake.jpg',
  //   services: [
  //     Service(
  //       userType: UserType.investor,
  //       experience: 5,
  //       serviceSubcategory: 'pro investor',
  //     ),
  //     Service(
  //       userType: UserType.agent,
  //       experience: 3,
  //       serviceSubcategory: 'house seller',
  //     ),
  //   ],
  //   address: 'HNO 654, street 2, West, Green Garden, Abogado',
  //   city: 'Anytown',
  //   country: 'USA',
  //   email: 'mahnoorhashmi4000@gmail.com',
  //   // membership: "Special Member",
  // ),
  // User(
  //   name: 'Hashim',
  //   image:
  //       'https://images.stockcake.com/public/0/3/1/0316b537-d898-429c-8d78-099e7df7a140_large/masked-urban-individual-stockcake.jpg',
  //   services: [
  //     Service(
  //       details: {},
  //     ),
  //     Service(name: 'Notary', experience: 3),
  //   ],
  //   address: '123 Main St',
  //   city: 'Anytown',
  //   country: 'USA',
  //   email: 'hashimamla123@gmail.com',
  //   // membership: 'Free Trial',
  // ),
];

// List<RealEstateListing> listings = [
//   RealEstateListing(
//     title: "Central House",
//     address: "Hno 786, street 67 north, wesex",
//     price: 180000,
//     country: "Germany",
//     city: "City",
//     state: "District",
//     description:
//         "The house is fully furnished and newly constructed contains all the facilities and a 10/10 in condition, interested person can contact at my given contact information.",
//     requestType: "request",
//     condition: "new",
//     propertyType: "conventional",
//     propertyCategory: "Bangalow",
//     propertySubCategory: "Royal Bangalow",
//     sellingType: "rental",
//     noOfBeds: 8,
//     noOfBathrooms: 8,
//     pictures: [
//       'https://images.stockcake.com/public/f/7/0/f7005cd1-6c21-4903-b28c-fbf3537c241e/luxury-estate-elegance-stockcake.jpg',
//       'https://images.stockcake.com/public/d/0/b/d0bc6c18-9f1a-46c9-aa01-3c8aa6855e09_large/luxurious-mansion-exterior-stockcake.jpg',
//     ],
//     furnished: true,
//     garage: true,
//     landAreaInTotal: 2400,
//     occupiedLandArea: 1200,
//   ),
//   RealEstateListing(
//     title: "The Pearls",
//     address: "Hno 786, street 67 north, wesex",
//     price: 280000,
//     country: "Germany",
//     city: "City",
//     state: "District",
//     description:
//         "The house is fully furnished and newly constructed contains all the facilities and a 10/10 in condition, interested person can contact at my given contact information.",
//     requestType: "request",
//     condition: "renovating",
//     propertyType: "commercial",
//     propertyCategory: "Bangalow",
//     propertySubCategory: "Royal Bangalow",
//     sellingType: "rental",
//     noOfBeds: 8,
//     noOfBathrooms: 8,
//     pictures: [
//       'https://images.stockcake.com/public/f/7/0/f7005cd1-6c21-4903-b28c-fbf3537c241e/luxury-estate-elegance-stockcake.jpg',
//       'https://images.stockcake.com/public/d/0/b/d0bc6c18-9f1a-46c9-aa01-3c8aa6855e09_large/luxurious-mansion-exterior-stockcake.jpg',
//     ],
//     furnished: false,
//     equipment: "Good equipment",
//     landAreaInTotal: 2400,
//     occupiedLandArea: 1200,
//     parkingPlaces: 2,
//   ),
// ];
List<String> servicesList = [
  UserType.investor.toCamelCaseString(),
  UserType.agent.toCamelCaseString(),
  UserType.consultant.toCamelCaseString(),
  UserType.lawyer.toCamelCaseString(),
  UserType.notary.toCamelCaseString(),
  UserType.appraiser.toCamelCaseString(),
  UserType.manager.toCamelCaseString(),
  UserType.loanBroker.toCamelCaseString(),
  UserType.economist.toCamelCaseString(),
  UserType.drawingMaker.toCamelCaseString(),
];

List<Map<String, String>> offerRequestMapping = [
  {
    'type': 'offer',
    'label': TranslationString.offer,
  },
  {
    'type': 'request',
    'label': TranslationString.request,
  },
];

final List<Map<String, String>> userMapping = [
  {'type': UserType.all.name, 'label': TranslationString.all},
  {'type': UserType.investor.name, 'label': TranslationString.investor},
  {'type': UserType.agent.name, 'label': TranslationString.agent},
  {'type': UserType.consultant.name, 'label': TranslationString.consultant},
  {'type': UserType.lawyer.name, 'label': TranslationString.lawyer},
  {'type': UserType.notary.name, 'label': TranslationString.notary},
  {'type': UserType.appraiser.name, 'label': TranslationString.appraiser},
  {'type': UserType.manager.name, 'label': TranslationString.manager},
  {'type': UserType.loanBroker.name, 'label': TranslationString.loanBroker},
  {'type': UserType.economist.name, 'label': TranslationString.economist},
  {'type': UserType.drawingMaker.name, 'label': TranslationString.drawingMaker},
  {
    'type': UserType.propertyAdmin.name,
    'label': TranslationString.propertyAdmin
  },
];

final List<Map<String, String>> userMappingSimple = [
  {'type': 'All', 'label': TranslationString.all},
  {'type': 'Investor', 'label': TranslationString.investor},
  {'type': 'Real Estate Agent', 'label': TranslationString.agent},
  {'type': 'Consultant', 'label': TranslationString.consultant},
  {'type': 'Lawyer', 'label': TranslationString.lawyer},
  {'type': 'Notary', 'label': TranslationString.notary},
  {'type': 'Appraiser', 'label': TranslationString.appraiser},
  {'type': 'Manager', 'label': TranslationString.manager},
  {'type': 'Loan Broker', 'label': TranslationString.loanBroker},
  {'type': 'Economist', 'label': TranslationString.economist},
  {'type': 'Drawing Maker', 'label': TranslationString.drawingMaker},
];

List<String> propertyTypes = ['commercial', 'conventional'];
List<String> sellingTypes = ['purchase', 'rental'];
List<String> conditions = ['new', 'old', 'renovating'];
List<String> requestType = ['offer', 'request'];
List<String> furnishedTypes = ['yes', 'no'];
List<String> commercialPropertyCategory = [
  'Select an Option',
  'Office Building',
  'Retail Space',
  'Hospitality',
  'Industrial Property',
  'Multifamily Residential',
  'Investment Property',
  'Mixed-Use Building',
  'Special Purpose',
];

List<List<String>> commercialPropertySubcategory = [
  [
    'Select an Option',
  ],
  [
    'Premium Workspace',
    'Co-Working Space',
    'Medical Office',
    'Coorporate Campus',
  ],
  [
    'Store',
    'Shopping Center',
    'Strip Mall',
    'Power Center',
  ],
  [
    'Hotel',
    'Motel',
    'Resort',
  ],
  [
    'Warehouse',
    'Manufacturing Facility',
    'Data Center',
    'Flex Space',
  ],
  [
    'Apartment Complex',
    'Student Hostel',
    'Senior Living',
  ],
  [
    'Office',
    'Retail',
    'Industrial',
    'Multi-Purpose',
  ],
  [
    'Urban Development',
    'Lifestyle Center',
    'Live-Work Space',
  ],
  [
    'Storage Facility',
    'Parking Facility',
    'Entertainment Venues',
    'Sports Center',
    'Gas & Utility',
  ],
];

List<String> conventionalPropertyCategory = [
  'Select an Option',
  'House',
  'Condominium',
  'Building Plot',
  'Agricultural Property',
  'Recreational Land',
  'Vacant land',
  'Governmental Property',
];
List<List<String>> conventionalPropertySubcategory = [
  [
    'Select an Option',
  ],
  [
    'Small House',
    'Duplex',
    'Triplex',
    'Town House,',
    'Luxury House',
  ],
  [
    'Standard',
    'Garden Condominium',
    'High Rise',
    'Pent House',
  ],
  [
    'Residential Plot',
    'Industrial Plot',
  ],
  [
    'Farm',
    'Ranch',
    'Orchard',
  ],
  [
    'Hunting Land',
    'Fishing Property',
    'Rural Retreat',
  ],
  [
    'Residential Lot',
    'Industrial Lot',
    'Raw Land',
    'Timber Land',
    'Development Land',
  ],
  [
    'Religious Building',
    'Educational Building',
    'Healthcare Facility',
    'Government Building',
  ],
];
List<String> experiencesList = [
  'below 5 years',
  '5 years',
  'above 5 years',
];

// List<Membership> memberships = [
//   Membership(
//     tag: "Free Trial",
//     points: [
//       "access to real estate section",
//       "view property listing and inquiries",
//       "post property listing and inquiries",
//     ],
//   ),
//   Membership(
//     tag: "Regular",
//     points: [
//       "free trial privileges",
//       "access to listed service providers",
//     ],
//   ),
//   Membership(
//     tag: "Premium",
//     points: [
//       "regular privileges",
//       "access to listed investors",
//     ],
//   ),
//   Membership(
//     tag: "Special Member",
//     points: [
//       "premium privileges",
//       "access to view and contact all users",
//     ],
//   ),
// ];

List<FAQ> faqs = [
  FAQ(
      question: "Can i contact any member of the app being free member?",
      textReply:
          "No, all the membership specifications can be read on the membership page and you can request for other memberships to get access to specific features."),
  FAQ(
      question: "What is this app about?",
      videoURL: "https://www.youtube.com/watch?v=X3i9SErMGD0"),
];

List<String> userCategories = [
  'Investor',
  'Customer',
  'Real Estate Agent',
  'Appraiser',
  'Notary',
  'Lawyer',
  'Property Manager',
  'Real Estate Consultant',
  'Real Estate Economist',
  'Real Estate Manager',
  'Property Administrator',
  'Real Estate Marketer',
  'Construction Drawing Maker',
  'Energy Consultant',
  'Facility Manager',
  'Loan Broker',
  'Financial Consultant',
];
