import '../models/user_model.dart';

class SessionService {
  static UserModel? currentUser;
  static String currentRole = 'buyer';

  static void login(UserModel user) => currentUser = user;

  static void logout() {
    currentUser = null;
    currentRole = 'buyer';
  }

  static void switchRole(String role) => currentRole = role;
}
