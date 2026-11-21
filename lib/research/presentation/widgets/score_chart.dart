import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:medquest/research/domain/models/score_chart_data.dart';

class ScoreChart extends StatelessWidget {
  final Map<String, List<ScoreChartData>> groupChartDataMap;

  const ScoreChart({Key? key, required this.groupChartDataMap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (groupChartDataMap.isEmpty) {
      return const Center(child: Text('Nenhum dado para exibir no gráfico.'));
    }

    final List<Color> groupColors = [
      Colors.black,
      Colors.deepPurple,
      Colors.green,
      Colors.orange,
      Colors.blue,
    ];

    int colorIndex = 0;
    final Map<String, Color> groupColorMap = {};

    List<LineChartBarData> lineBars = groupChartDataMap.entries.map((entry) {
      final groupName = entry.key;
      final points = entry.value;

      final color = groupColors[colorIndex % groupColors.length];
      groupColorMap[groupName] = color;
      colorIndex++;

      return LineChartBarData(
        spots: points.map((d) => FlSpot(d.weekIndex, d.averageScore)).toList(),
        color: color,
        barWidth: 2,
        isCurved: false,
        dotData: FlDotData(show: true),
      );
    }).toList();

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.5,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1.0, 
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        meta: meta,
                        space: 8,
                        child: Text(
                          'T${value.toInt()}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              lineBarsData: lineBars,
            ),
          ),
        ),
        
        const SizedBox(height: 16),

        Wrap(
          spacing: 16.0,
          runSpacing: 8.0,
          alignment: WrapAlignment.center,
          children: groupColorMap.entries.map((entry) {
            final groupName = entry.key;
            final color = entry.value;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  groupName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}