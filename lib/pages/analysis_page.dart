import 'package:flutter/material.dart';
import '../models/analysis_args.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsArgs = ModalRoute.of(context)?.settings.arguments;
    // Geriye dönük uyumluluk: Map gelirse olabildiğince dönüştür.
    final AnalysisArgs args = switch (settingsArgs) {
      AnalysisArgs a => a,
      Map m => AnalysisArgs(
          imagePath: m['imagePath'] as String?,
          ocrText: m['ocrText'] as String?,
          productName: m['productName'] as String?,
          barcode: m['barcode'] as String?,
        ),
      _ => const AnalysisArgs(),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analiz'),
        actions: [
          if ((args.ocrText ?? '').isNotEmpty)
            IconButton(
              tooltip: 'Kopyala',
              onPressed: () {
                final _ = args.ocrText!;
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Metin panoya kopyalandı')));
                // ignore: deprecated_member_use
                // Clipboard.setData(ClipboardData(text: text));
              },
              icon: const Icon(Icons.copy_all_rounded),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (args.productName != null || args.barcode != null)
            Card(
              child: ListTile(
                leading: const Icon(Icons.qr_code_2_rounded),
                title: Text(args.productName ?? 'Ürün'),
                subtitle: Text(args.barcode ?? ''),
              ),
            ),
          if ((args.imagePath ?? '').isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: (args.imagePath!.startsWith('http'))
                  ? Image.network(args.imagePath!, fit: BoxFit.cover)
                  : Image.asset(args.imagePath!, fit: BoxFit.cover),
            ),
          ],
          const SizedBox(height: 16),
          Text('Tanımlanan Metin', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: SelectableText(
              (args.ocrText ?? '').isEmpty ? 'Metin bulunamadı.' : args.ocrText!,
              style: const TextStyle(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}