import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart' show Client, ID;
import 'package:appwrite/appwrite.dart' as Appwrite;
import 'package:appwrite/models.dart' show User;

class Account extends ChangeNotifier {
  final Appwrite.Account _account;

  bool get isAuthenticated => _user != null;

  User? _user;
  User? get user => _user;

  Account(Client client) : _account = Appwrite.Account(client);

  Future<void> init() async {
    try {
      _user = await _account.get();
      
      notifyListeners();
    } catch(e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> authenticate({required String email, required String password}) async {
    try {
      await _account.createEmailSession(email: email, password: password);
      
      await init();
    } catch(e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> deauthenticate() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      
      _user = null;

      notifyListeners();

      await init();
    } catch(e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> register({required String username, required String email, required String password}) async {
    try {
      await _account.create(
        userId: ID.unique(),
        email: email,
        name: username,
        password: password
      );

      await authenticate(email: email, password: password);
    } catch(e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}