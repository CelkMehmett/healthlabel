import 'package:flutter/material.dart';
import '../models/history_item.dart';

class HistoryDetailPage extends StatelessWidget {
  static const route = '/historyDetail';
  final HistoryItem item;
  const HistoryDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Chip(label: Text(item.riskLevel.name.toUpperCase()), backgroundColor: cs.primaryContainer),
              const SizedBox(width: 12),
              Text('${item.date.toLocal()}'),
            ],
          ),
          const SizedBox(height: 12),
          if (item.imagePath != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(item.imagePath!, height: 180, fit: BoxFit.cover),
            ),
            const SizedBox(height: 12),
          ],
          Text('OCR', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SelectableText(item.ocrText),
        ],
      ),
    );
  }
}
