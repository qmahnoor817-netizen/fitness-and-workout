import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class WeightChart extends StatelessWidget {
  final List<Map<String, dynamic>> weightData; // [{date: DateTime, weight: double}]

  const WeightChart({super.key, required this.weightData});

  @override
  Widget build(BuildContext context) {
    if (weightData.isEmpty) {
      return const Center(child: Text('No data yet. Add your weight!'));
    }

    return LineChart(
      LineChartData(
        minY: weightData.map((e) => e['weight']).reduce((a, b) => a < b? a : b) - 2,
        maxY: weightData.map((e) => e['weight']).reduce((a, b) => a > b? a : b) + 2,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text('${value.toInt()}kg', style: const TextStyle(fontSize: 10)),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: (weightData.length / 4).ceilToDouble(),
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < weightData.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(DateFormat('dd/MM').format(weightData[index]['date']),
                        style: const TextStyle(fontSize: 10)),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: weightData.asMap().entries.map((e) =>
                FlSpot(e.key.toDouble(), e.value['weight'])).toList(),
            isCurved: true,
            color: const Color(0xFF3F51B5),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 4,
                color: const Color(0xFF3F51B5),
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF3F51B5).withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}