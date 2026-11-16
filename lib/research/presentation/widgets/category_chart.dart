import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:medquest/patient/domain/models/patient_entity.dart';
import 'package:signals_flutter/signals_flutter.dart';

class CategoryChart extends StatelessWidget {
  final List<Patient> patients;
  final List<Map<String, String>>
  availableAttributes; 

  CategoryChart({required this.patients, required this.availableAttributes});

  Map<String, double> calculatePercentages(String attributeKey) {
    final Map<String, int> counts = {};
    
    for (var patient in patients) {
      final String value = patient.getAttributeValue(attributeKey);
      counts[value] = (counts[value] ?? 0) + 1;
    }

    final int total = patients.length;
    if (total == 0) return {};

    final Map<String, double> percentages = {};
    counts.forEach((key, count) {
      percentages[key] = (count / total) * 100;
    });

    return percentages;
  }
  @override
  Widget build(BuildContext context) {
    final selectedAttrSignal = signal<String>(
      availableAttributes.first['key']!,
    );

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Selecione uma categoria:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Watch(
                  (context) => DropdownButton<String>(
                    value: selectedAttrSignal.value,
                    items: availableAttributes.map((attr) {
                      return DropdownMenuItem(
                        value: attr['key'],
                        child: Text(attr['label']!),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) selectedAttrSignal.value = val;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: 200,
              child: Watch((context) {
                final currentAttr = selectedAttrSignal.value;
                final dataMap = calculatePercentages(currentAttr);

                if (dataMap.isEmpty) {
                  return const Center(child: Text('Nenhum dado disponível'));
                }

                return _buildPieChart(dataMap);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(Map<String, double> dataMap) {
    return PieChart(
      PieChartData(
        sections: dataMap.entries.map((entry) {
          return PieChartSectionData(
            value: entry.value,
            title: '${entry.key}: ${entry.value.toStringAsFixed(1)}%',
            color: Colors.primaries[dataMap.keys.toList().indexOf(entry.key) % Colors.primaries.length],
          );
        }).toList(),
      ),
    );
  }
}
