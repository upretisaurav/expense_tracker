import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/src/data/model/expense.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

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
