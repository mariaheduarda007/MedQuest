// import 'package:material_ui/material_ui.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:medquest/patient/domain/models/patient_entity.dart';
import 'package:signals_flutter/signals_flutter.dart';

class CategoryChart extends StatefulWidget {
  final List<Patient> patients;
  final List<Map<String, String>> availableAttributes; 

  const CategoryChart({
    super.key,
    required this.patients,
    required this.availableAttributes,
  });

  @override
  State<CategoryChart> createState() => _CategoryChartState();
}

class _CategoryChartState extends State<CategoryChart> {
  // O signal é declarado aqui no State para persistir durante todo o ciclo de vida do widget
  late final Signal<String> selectedAttrSignal;

  @override
  void initState() {
    super.initState();
    selectedAttrSignal = signal<String>(widget.availableAttributes.first['key']!);
  }

  Map<String, double> calculatePercentages(String attributeKey) {
    final Map<String, int> counts = {};
    
    for (var patient in widget.patients) {
      final String value = patient.getAttributeValue(attributeKey);
      counts[value] = (counts[value] ?? 0) + 1;
    }

    final int total = widget.patients.length;
    if (total == 0) return {};

    final Map<String, double> percentages = {};
    counts.forEach((key, count) {
      percentages[key] = (count / total) * 100;
    });

    return percentages;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
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
                    'Categoria:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Watch(
                      (context) => DropdownButton<String>(
                        isExpanded: true,
                        value: selectedAttrSignal.value,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                        items: widget.availableAttributes.map((attr) {
                          return DropdownMenuItem(
                            value: attr['key'],
                            child: Text(
                              attr['label']!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            selectedAttrSignal.value = val;
                          }
                        },
                      ),
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

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: _buildPieChart(dataMap),
                  );
                }),
              ),
            ],
          ),
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