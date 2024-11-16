import 'package:flutter/foundation.dart';

class TrendData {
  final List<String> dates;
  final List<double> original;
  final List<double> trend;

  TrendData({
    required this.dates,
    required this.original,
    required this.trend,
  });

  factory TrendData.fromJson(Map<String, dynamic> json) {
    return TrendData(
      dates: List<String>.from(json['dates']),
      original: List<double>.from(json['original']),
      trend: List<double>.from(json['trend']),
    );
  }
}

class TrendProvider with ChangeNotifier {
  TrendData? _trendData;
  bool _isLoading = false;
  String? _error;

  TrendData? get trendData => _trendData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> updateTrendData(Map<String, dynamic> trendResponse) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _trendData = TrendData.fromJson(trendResponse);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearTrendData() {
    _trendData = null;
    _error = null;
    notifyListeners();
  }
}
