import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/src/data/model/expense.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  /// Sign up a new user
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String profession,
    required String photo,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/signup');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'profession': profession,
          'photo': photo,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw HttpException(
            'Failed to sign up. Status code: ${response.statusCode}, Message: ${response.body}');
      }
    } catch (e) {
      throw HttpException('Sign-up failed: $e');
    }
  }

  /// Sign in an existing user
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/signin');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw HttpException(
            'Failed to sign in. Status code: ${response.statusCode}, Message: ${response.body}');
      }
    } catch (e) {
      throw HttpException('Sign-in failed: $e');
    }
  }

  /// Get user profile by user ID
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final url = Uri.parse('$baseUrl/user/$userId');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw HttpException(
            'Failed to fetch profile. Status code: ${response.statusCode}, Message: ${response.body}');
      }
    } catch (e) {
      throw HttpException('Fetching profile failed: $e');
    }
  }

  /// Send expenses to analyze trends
  Future<Map<String, dynamic>> sendExpenses(List<Expense> expenses) async {
    final url = Uri.parse('$baseUrl/trend-analysis');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body:
            jsonEncode({'expenses': expenses.map((e) => e.toJson()).toList()}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse.containsKey('dates') &&
            jsonResponse.containsKey('original') &&
            jsonResponse.containsKey('trend')) {
          return jsonResponse;
        } else {
          throw const FormatException('Invalid response format from server');
        }
      } else {
        throw HttpException(
            'Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return {
        "dates": <String>[],
        "original": <double>[],
        "trend": <double>[],
      };
    }
  }
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);

  @override
  String toString() => message;
}
