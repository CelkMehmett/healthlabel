import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Risk seviyeleri dağılımı için örnek PieChart widget'ı
Widget riskPieChart(Map<String, int> riskCounts) {
  final sections = riskCounts.entries.map((e) => PieChartSectionData(
    value: e.value.toDouble(),
    color: e.key == 'safe' ? Colors.green : e.key == 'attention' ? Colors.orange : Colors.red,
    title: '${e.value}',
  )).toList();

  return PieChart(PieChartData(sections: sections));
}