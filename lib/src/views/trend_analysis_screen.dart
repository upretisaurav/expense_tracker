import 'package:expense_tracker/src/providers/trend_provider.dart';
import 'package:expense_tracker/src/styles/color_styles.dart';
import 'package:expense_tracker/widgets/screen_title.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class TrendAnalysisScreen extends StatelessWidget {
  const TrendAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TrendProvider>(
      builder: (context, trendProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xfff2f4f7),
          body: _buildBody(trendProvider),
        );
      },
    );
  }

  Widget _buildBody(TrendProvider trendProvider) {
    if (trendProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: ColorStyles.primaryColor,
        ),
      );
    }

    if (trendProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              FeatherIcons.alertCircle,
              size: 48,
              color: ColorStyles.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error: ${trendProvider.error}',
              style: const TextStyle(
                color: ColorStyles.primaryTextColor,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final trendData = trendProvider.trendData;
    if (trendData == null ||
        trendData.dates.isEmpty ||
        trendData.original.isEmpty ||
        trendData.trend.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FeatherIcons.barChart2,
              size: 48,
              color: ColorStyles.secondaryTextColor,
            ),
            SizedBox(height: 16),
            Text(
              'No trend data available yet',
              style: TextStyle(
                color: ColorStyles.primaryTextColor,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add more expenses to see trends',
              style: TextStyle(
                color: ColorStyles.secondaryTextColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const ScreenTitle(title: "Trend Analysis"),
            const SizedBox(height: 16),
            const Text(
              'This chart shows your actual expenses (blue line) compared to the underlying trend (table below)',
              style: TextStyle(
                fontSize: 14,
                color: ColorStyles.secondaryTextColor,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildLineChart(trendData.dates, trendData.original),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Trend Analysis Table',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ColorStyles.primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'The trend values show your underlying spending pattern after removing daily fluctuations. Higher values indicate periods of increased spending.',
              style: TextStyle(
                fontSize: 14,
                color: ColorStyles.secondaryTextColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildTrendTable(trendData.dates, trendData.trend),
            const SizedBox(height: 8),
            const Text(
              'Note: The data shown is calculated based on all available data, rather than daily, weekly, or monthly, to provide a testing trend analysis.',
              style: TextStyle(
                fontSize: 12,
                color: ColorStyles.secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendTable(List<String> dates, List<double> trend) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Table(
          border: TableBorder.all(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorStyles.primaryTextColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Trend',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorStyles.primaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
            ...List.generate(dates.length, (index) {
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      dates[index],
                      style:
                          const TextStyle(color: ColorStyles.primaryTextColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      trend[index].toStringAsFixed(2),
                      style:
                          const TextStyle(color: ColorStyles.primaryTextColor),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(List<String> dates, List<double> original) {
    final labelInterval = (dates.length / 5).ceil();
    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: original
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                  .toList(),
              isCurved: true,
              color: ColorStyles.primaryColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: ColorStyles.primaryColor.withOpacity(0.1),
              ),
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: labelInterval.toDouble(),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 &&
                      index < dates.length &&
                      index % labelInterval == 0) {
                    return Transform.rotate(
                      angle: -0.5,
                      child: Text(
                        dates[index],
                        style: TextStyle(
                          color: ColorStyles.primaryTextColor.withOpacity(0.7),
                          fontSize: 10,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                interval: _calculateInterval(original),
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: TextStyle(
                      color: ColorStyles.primaryTextColor.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _calculateInterval(original),
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.shade200,
                strokeWidth: 1,
              );
            },
          ),
        ),
      ),
    );
  }

  double _calculateInterval(List<double> values) {
    final max = values.reduce((curr, next) => curr > next ? curr : next);
    final min = values.reduce((curr, next) => curr < next ? curr : next);
    final range = max - min;
    return (range / 5).roundToDouble();
  }
}
