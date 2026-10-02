// ==================== AUTHENTICATION ====================

class ForgetPass {
  String email;
  ForgetPass({required this.email});
  Map<String, dynamic> toJson() => {'email': email};
  factory ForgetPass.fromJson(Map<String, dynamic> j) =>
      ForgetPass(email: j['email']);
}

class AdminLogin {
  String email, pass;
  AdminLogin({required this.email, required this.pass});
  Map<String, dynamic> toJson() => {'email': email, 'pass': pass};
  factory AdminLogin.fromJson(Map<String, dynamic> j) =>
      AdminLogin(email: j['email'], pass: j['pass']);
}

class AdminSignup {
  String fname, lname, email, pass;
  AdminSignup({
    required this.fname,
    required this.lname,
    required this.email,
    required this.pass,
  });
  Map<String, dynamic> toJson() => {
    'fname': fname,
    'lname': lname,
    'email': email,
    'pass': pass,
  };
  factory AdminSignup.fromJson(Map<String, dynamic> j) => AdminSignup(
    fname: j['fname'],
    lname: j['lname'],
    email: j['email'],
    pass: j['pass'],
  );
}

// ==================== BID MONITORING ====================

class ViewBids {
  String bidId, carId, buyerId, status;
  double bidAmount;
  ViewBids({
    required this.bidId,
    required this.carId,
    required this.buyerId,
    required this.bidAmount,
    required this.status,
  });
  Map<String, dynamic> toJson() => {
    'bidId': bidId,
    'carId': carId,
    'buyerId': buyerId,
    'bidAmount': bidAmount,
    'status': status,
  };
  factory ViewBids.fromJson(Map<String, dynamic> j) => ViewBids(
    bidId: j['bidId'],
    carId: j['carId'],
    buyerId: j['buyerId'],
    bidAmount: j['bidAmount'],
    status: j['status'],
  );
}

class RemoveBid {
  String bidId, reason;
  RemoveBid({required this.bidId, required this.reason});
  Map<String, dynamic> toJson() => {'bidId': bidId, 'reason': reason};
  factory RemoveBid.fromJson(Map<String, dynamic> j) =>
      RemoveBid(bidId: j['bidId'], reason: j['reason']);
}

// ==================== CAR LISTING MONITORING ====================

class ViewListings {
  String listingId, sellerId, carModel, carBrand, status;
  double price;
  ViewListings({
    required this.listingId,
    required this.sellerId,
    required this.carModel,
    required this.carBrand,
    required this.price,
    required this.status,
  });
  Map<String, dynamic> toJson() => {
    'listingId': listingId,
    'sellerId': sellerId,
    'carModel': carModel,
    'carBrand': carBrand,
    'price': price,
    'status': status,
  };
  factory ViewListings.fromJson(Map<String, dynamic> j) => ViewListings(
    listingId: j['listingId'],
    sellerId: j['sellerId'],
    carModel: j['carModel'],
    carBrand: j['carBrand'],
    price: j['price'],
    status: j['status'],
  );
}

class ApproveListing {
  String listingId, adminId, status;
  ApproveListing({
    required this.listingId,
    required this.adminId,
    required this.status,
  });
  Map<String, dynamic> toJson() => {
    'listingId': listingId,
    'adminId': adminId,
    'status': status,
  };
  factory ApproveListing.fromJson(Map<String, dynamic> j) => ApproveListing(
    listingId: j['listingId'],
    adminId: j['adminId'],
    status: j['status'],
  );
}

class DeleteListing {
  String listingId, reason;
  DeleteListing({required this.listingId, required this.reason});
  Map<String, dynamic> toJson() => {'listingId': listingId, 'reason': reason};
  factory DeleteListing.fromJson(Map<String, dynamic> j) =>
      DeleteListing(listingId: j['listingId'], reason: j['reason']);
}

// ==================== REPORT COMPLAINT ====================

class ViewReport {
  String reportId, reportedBy, reason, status;
  ViewReport({
    required this.reportId,
    required this.reportedBy,
    required this.reason,
    required this.status,
  });
  Map<String, dynamic> toJson() => {
    'reportId': reportId,
    'reportedBy': reportedBy,
    'reason': reason,
    'status': status,
  };
  factory ViewReport.fromJson(Map<String, dynamic> j) => ViewReport(
    reportId: j['reportId'],
    reportedBy: j['reportedBy'],
    reason: j['reason'],
    status: j['status'],
  );
}

class ResolveReport {
  String reportId, adminId, resolution;
  ResolveReport({
    required this.reportId,
    required this.adminId,
    required this.resolution,
  });
  Map<String, dynamic> toJson() => {
    'reportId': reportId,
    'adminId': adminId,
    'resolution': resolution,
  };
  factory ResolveReport.fromJson(Map<String, dynamic> j) => ResolveReport(
    reportId: j['reportId'],
    adminId: j['adminId'],
    resolution: j['resolution'],
  );
}

class DismissReport {
  String reportId, adminId, dismissReason;
  DismissReport({
    required this.reportId,
    required this.adminId,
    required this.dismissReason,
  });
  Map<String, dynamic> toJson() => {
    'reportId': reportId,
    'adminId': adminId,
    'dismissReason': dismissReason,
  };
  factory DismissReport.fromJson(Map<String, dynamic> j) => DismissReport(
    reportId: j['reportId'],
    adminId: j['adminId'],
    dismissReason: j['dismissReason'],
  );
}

// ==================== SYSTEM ANALYTICS ====================

class UserStats {
  int totalUsers, activeUsers, bannedUsers;
  UserStats({
    required this.totalUsers,
    required this.activeUsers,
    required this.bannedUsers,
  });
  Map<String, dynamic> toJson() => {
    'totalUsers': totalUsers,
    'activeUsers': activeUsers,
    'bannedUsers': bannedUsers,
  };
  factory UserStats.fromJson(Map<String, dynamic> j) => UserStats(
    totalUsers: j['totalUsers'],
    activeUsers: j['activeUsers'],
    bannedUsers: j['bannedUsers'],
  );
}

class ListingStats {
  int totalListings, approvedListings, deletedListings, pendingListings;
  ListingStats({
    required this.totalListings,
    required this.approvedListings,
    required this.deletedListings,
    required this.pendingListings,
  });
  Map<String, dynamic> toJson() => {
    'totalListings': totalListings,
    'approvedListings': approvedListings,
    'deletedListings': deletedListings,
    'pendingListings': pendingListings,
  };
  factory ListingStats.fromJson(Map<String, dynamic> j) => ListingStats(
    totalListings: j['totalListings'],
    approvedListings: j['approvedListings'],
    deletedListings: j['deletedListings'],
    pendingListings: j['pendingListings'],
  );
}

// ==================== USER MANAGEMENT ====================

class ViewUsers {
  String userId, fname, lname, email, status;
  ViewUsers({
    required this.userId,
    required this.fname,
    required this.lname,
    required this.email,
    required this.status,
  });
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'fname': fname,
    'lname': lname,
    'email': email,
    'status': status,
  };
  factory ViewUsers.fromJson(Map<String, dynamic> j) => ViewUsers(
    userId: j['userId'],
    fname: j['fname'],
    lname: j['lname'],
    email: j['email'],
    status: j['status'],
  );
}

class BanUser {
  String userId, adminId, reason;
  BanUser({required this.userId, required this.adminId, required this.reason});
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'adminId': adminId,
    'reason': reason,
  };
  factory BanUser.fromJson(Map<String, dynamic> j) =>
      BanUser(userId: j['userId'], adminId: j['adminId'], reason: j['reason']);
}

class DeleteUser {
  String userId, adminId, reason;
  DeleteUser({
    required this.userId,
    required this.adminId,
    required this.reason,
  });
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'adminId': adminId,
    'reason': reason,
  };
  factory DeleteUser.fromJson(Map<String, dynamic> j) => DeleteUser(
    userId: j['userId'],
    adminId: j['adminId'],
    reason: j['reason'],
  );
}
