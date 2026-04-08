import 'package:flutter/material.dart';
import '../data/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  bool _isLoading = false;
  String? _errorMessage;
  bool _sessionExpired = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get sessionExpired => _sessionExpired;

  String? get userEmail => _authService.currentUser?.email;
  String? get userId => _authService.currentUser?.uid;
  DateTime? get lastSignInTime => _authService.currentUser?.metadata.lastSignInTime;

  AuthProvider(this._authService) {
    _checkSession();
  }

  Future<void> _checkSession() async {
    _isLoading = true; // Set loading while checking
    notifyListeners();

    final user = _authService.currentUser;
    if (user != null) {
      try {
        await user.reload();
      } catch (e) {
        _sessionExpired = true;
        await logout();
      }
    }

    _isLoading = false; // Check complete
    notifyListeners();
  }

  void clearSessionError() {
    _sessionExpired = false;
    notifyListeners();
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _sessionExpired = false;
    notifyListeners();

    try {
      await _authService.login(email, password);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.register(email, password);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }

  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
