enum UserType {
  all,
  investor,
  notary,
  appraiser,
  customer,
  agent,
  lawyer,
  consultant,
  economist,
  manager,
  propertyAdmin,
  marketer,
  drawingMaker,
  facilityManager,
  loanBroker,
}

extension UserTypeExtension on UserType {
  String toCamelCaseString() {
    switch (this) {
      case UserType.all:
        return 'All';
      case UserType.investor:
        return 'Investor';
      case UserType.notary:
        return 'Notary';
      case UserType.appraiser:
        return 'Appraiser';
      case UserType.customer:
        return 'Customer';
      case UserType.agent:
        return 'Real Estate Agent';
      case UserType.lawyer:
        return 'Lawyer';
      case UserType.consultant:
        return 'Consultant';
      case UserType.economist:
        return 'Economist';
      case UserType.manager:
        return 'Manager';
      case UserType.propertyAdmin:
        return 'Administrator';
      case UserType.marketer:
        return 'Marketer';
      case UserType.drawingMaker:
        return 'Drawing Maker';
      case UserType.loanBroker:
        return 'Loan Broker';
      default:
        return 'All';
    }
  }
}
