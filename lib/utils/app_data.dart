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
