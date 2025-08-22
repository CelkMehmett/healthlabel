import 'dart:math';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/history_item.dart';           // RiskLevel & HistoryItem
import '../services/analysis_service.dart';     // AnalysisService.analyze
import '../repository/history_repository.dart'; // Geçmişe kaydetme

class AnalysisScreen extends StatelessWidget {
  final String? imagePath;
  final String ocrText;

  const AnalysisScreen({
    super.key,
    this.imagePath,
    required this.ocrText,
  });

  @override
  Widget build(BuildContext context) {
    final _ = Theme.of(context).colorScheme;

    // analyze() RiskLevel döndürür (nesne değil)
    final RiskLevel risk = AnalysisService.analyze(ocrText);

    // Ürün adı türet (OCR içinden veya ilk anlamlı satır)
    final String name =
        RegExp(r'^\s*Product\s*:\s*(.+)$', multiLine: true).firstMatch(ocrText)?.group(1) ??
        RegExp(r'^[A-Za-zÇĞİÖŞÜçğıöşü0-9 \-]{3,}', multiLine: true).firstMatch(ocrText)?.group(0) ??
        'Unknown';

    Color levelColor(RiskLevel l) {
      switch (l) {
        case RiskLevel.safe:
          return Colors.green;
        case RiskLevel.attention:
          return Colors.orange;
        case RiskLevel.risky:
          return Colors.red;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Analiz Sonucu')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (imagePath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath!,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  label: Text(risk.name.toUpperCase()),
                  backgroundColor: levelColor(risk).withAlpha(38),
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'OCR',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SelectableText(ocrText),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Share.share('Product: $name\nRisk: ${risk.name}\n\n$ocrText');
                    },
                    child: const Text('Paylaş'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      final id = '${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(99999)}';
                      final item = HistoryItem(
                        id: id,
                        name: name,
                        date: DateTime.now(),
                        riskLevel: risk,
                        ocrText: ocrText,
                        imagePath: imagePath,
                      );
                      await HistoryRepository.I.add(item);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Geçmişe kaydedildi')),
                        );
                      }
                    },
                    child: const Text('Kaydet ve Geçmişe Ekle'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
