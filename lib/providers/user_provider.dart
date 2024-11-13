import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  List<UserModel> _users = [];
  bool _isLoading = true;
  String _error = '';

  // Getter for the list of users
  List<UserModel> get users => _users;

  // Getter for loading status
  bool get isLoading => _isLoading;

  // Getter for error message
  String get error => _error;

  final ApiService _apiService = ApiService();

  // Fetch users from the API
  Future<void> fetchUsers() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _users = await _apiService.fetchUsers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void refresh() async {
    await fetchUsers();
  }
}
