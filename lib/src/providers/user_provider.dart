import 'package:expense_tracker/src/data/model/user.dart';
import 'package:expense_tracker/src/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? _userId;
  // ignore: constant_identifier_names
  static const String USER_ID_KEY = 'user_id';

  String? get userId => _userId;
  bool get isAuthenticated => _userId != null;

  UserProvider() {
    _loadUserId();
  }

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ApiService _apiService = GetIt.instance<ApiService>();

  Future<void> fetchUserProfile() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userIdFetch = _userId;
      final userData = await _apiService.getUserProfile(userIdFetch!);
      _user = User.fromJson(userData);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString(USER_ID_KEY);
    notifyListeners();
  }

  Future<void> setUserId(String userId) async {
    _userId = userId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(USER_ID_KEY, userId);
    notifyListeners();
  }

  Future<void> clearUserId() async {
    _userId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(USER_ID_KEY);
    notifyListeners();
  }
}
