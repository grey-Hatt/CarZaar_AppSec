import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/connects_service.dart';
import '../services/session_service.dart';

class AppProvider extends ChangeNotifier {
  UserModel? currentUser;
  String currentRole = 'buyer';
  int connectsBalance = 0;

  bool get isLoggedIn => currentUser != null;

  void login(UserModel user) {
    currentUser = user;
    SessionService.login(user);
    notifyListeners();
  }

  void updateUser(UserModel user) {
    currentUser = user;
    SessionService.login(user);
    notifyListeners();
  }

  void logout() {
    currentUser = null;
    currentRole = 'buyer';
    connectsBalance = 0;
    SessionService.logout();
    notifyListeners();
  }

  void switchRole(String role) {
    currentRole = role;
    SessionService.switchRole(role);
    notifyListeners();
  }

  Future<void> loadConnects() async {
    final user = currentUser;
    if (user?.id == null) return;
    connectsBalance = await ConnectsService().getBalance(user!.id!);
    notifyListeners();
  }
}
