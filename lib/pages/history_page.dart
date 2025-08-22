import 'package:flutter/material.dart';
import '../widgets/risk_pie_chart.dart';
import '../repository/history_repository.dart';
import '../models/history_item.dart';
import 'history_detail_page.dart';

class HistoryPage extends StatelessWidget {
  static const route = '/history';
  final String lang;
  const HistoryPage({super.key, required this.lang});

  Map<String, int> _riskCounts(List<HistoryItem> list) {
    final map = {'safe':0, 'attention':0, 'risky':0};
    for (final it in list) {
      map[it.riskLevel.name] = (map[it.riskLevel.name] ?? 0) + 1;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Geçmiş')),
      body: ValueListenableBuilder<List<HistoryItem>>(
        valueListenable: HistoryRepository.I.items,
        builder: (context, items, _) {
          final counts = _riskCounts(items);
          if (items.isEmpty) {
            return const Center(child: Text('Henüz bir kayıt yok.'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final item = items[i];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.date.toLocal().toString()),
                      trailing: Text(item.riskLevel.name),
                      onTap: () => Navigator.pushNamed(
                        context,
                        HistoryDetailPage.route,
                        arguments: item,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(height: 160, child: riskPieChart(counts)),
              ),
            ],
          );
        },
      ),
    );
  }
}
