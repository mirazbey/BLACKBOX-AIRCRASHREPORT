import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';

class AuthService extends ChangeNotifier {
  static const String _prefUserKey = 'bureau_auth_user_v1';
  
  BureauUser? _currentUser;
  bool _isLoading = false;

  BureauUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  bool get isIosPlatform => defaultTargetPlatform == TargetPlatform.iOS;

  AuthService() {
    _loadPersistedUser();
  }

  Future<void> _loadPersistedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_prefUserKey);
      if (userJson != null) {
        final data = jsonDecode(userJson) as Map<String, dynamic>;
        _currentUser = BureauUser.fromJson(data);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading persisted user: $e');
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate real Google OAuth token verification and profile retrieval
      await Future.delayed(const Duration(milliseconds: 900));

      final user = BureauUser(
        uid: 'goog_usr_${DateTime.now().millisecondsSinceEpoch}',
        displayName: 'Müfettiş Demir (Google)',
        email: 'investigator.demir@gmail.com',
        providerType: AuthProviderType.google,
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
        badgeNumber: '#44102',
        rank: 'BAŞMÜFETTİŞ (LEAD INVESTIGATOR)',
        clearanceLevel: 4,
        totalCasesSolved: 14,
        totalXp: 18450,
        isVerifiedFederal: true,
      );

      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefUserKey, jsonEncode(user.toJson()));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate native Sign in with Apple credential handshake
      await Future.delayed(const Duration(milliseconds: 900));

      final user = BureauUser(
        uid: 'appl_usr_${DateTime.now().millisecondsSinceEpoch}',
        displayName: 'Müfettiş Demir (Apple)',
        email: 'investigator.demir@icloud.com',
        providerType: AuthProviderType.apple,
        avatarUrl: null,
        badgeNumber: '#44102',
        rank: 'BAŞMÜFETTİŞ (LEAD INVESTIGATOR)',
        clearanceLevel: 4,
        totalCasesSolved: 14,
        totalXp: 18450,
        isVerifiedFederal: true,
      );

      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefUserKey, jsonEncode(user.toJson()));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefUserKey);
    notifyListeners();
  }
}
