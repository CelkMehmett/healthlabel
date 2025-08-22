import 'package:flutter/material.dart';
import '../repository/history_repository.dart';
import '../models/history_item.dart';
import 'history_detail_page.dart';

class HistoryContent extends StatefulWidget {
  final String lang;
  const HistoryContent({super.key, required this.lang});
  @override
  State<HistoryContent> createState() => _HistoryContentState();
}

class _HistoryContentState extends State<HistoryContent> {
  final _searchCtrl = TextEditingController();
  bool _onlyRisky = false;

  Color levelColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.safe:
        return Colors.green;
      case RiskLevel.risky:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  List<HistoryItem> _filter(List<HistoryItem> src) {
    final q = _searchCtrl.text.trim().toLowerCase();
    var list = src;
    if (q.isNotEmpty) {
      list = list.where((e) => e.name.toLowerCase().contains(q) || e.ocrText.toLowerCase().contains(q)).toList();
    }
    if (_onlyRisky) list = list.where((e) => e.riskLevel == RiskLevel.risky).toList();
    return list.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    String t(String tr, String en, [String de = '', String fr = '']) {
      switch (widget.lang) {
        case 'tr': return tr;
        case 'en': return en;
        case 'de': return de.isNotEmpty ? de : en;
        case 'fr': return fr.isNotEmpty ? fr : en;
        default: return en;
      }
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: t('Ara...', 'Search...', 'Suche...', 'Rechercher...'),
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Column(children: [
                Text(t('Sadece riskli', 'Only risky', 'Nur riskant', 'Seulement risqué')),
                Switch(value: _onlyRisky, onChanged: (v) => setState(() => _onlyRisky = v)),
              ]),
            ]),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<HistoryItem>>(
              valueListenable: HistoryRepository.I.items,
              builder: (context, items, _) {
                final data = _filter(items);
                if (data.isEmpty) return const Center(child: Text('Kayıt yok'));
                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final it = data[i];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: levelColor(it.riskLevel).withAlpha(38),
                          child: Icon(Icons.inventory_2, color: levelColor(it.riskLevel)),
                        ),
                        title: Text(it.name.isEmpty ? 'Product' : it.name),
                        subtitle: Text('${it.date}'),
                        trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
                        onTap: () => Navigator.pushNamed(context, HistoryDetailPage.route, arguments: it),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}