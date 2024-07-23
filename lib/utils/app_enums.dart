enum UserType {
  investor,
  notary,
  appraiser,
  customer,
  agent,
  lawyer,
}

extension UserTypeExtension on UserType {
  String toCamelCaseString() {
    switch (this) {
      case UserType.investor:
        return 'Investor';
      case UserType.notary:
        return 'Notary';
      case UserType.appraiser:
        return 'Appraiser';
      case UserType.customer:
        return 'Customer';
      case UserType.agent:
        return 'Agent';
      case UserType.lawyer:
        return 'Lawyer';
      default:
        return '';
    }
  }
}
