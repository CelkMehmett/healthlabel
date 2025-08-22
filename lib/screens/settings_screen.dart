import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final String lang;
  final ValueChanged<String> onLangChange;
  final ValueChanged<List<String>> onHealthChange;
  final List<String> selectedHealth;

  const SettingsScreen({
    super.key,
    required this.lang,
    required this.onLangChange,
    required this.selectedHealth,
    required this.onHealthChange,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Set<String> healthRisks;

  static const allRisks = [
    {'key': 'diabetes', 'tr': 'Şeker Hastalığı', 'en': 'Diabetes'},
    {'key': 'gluten', 'tr': 'Gluten Hassasiyeti', 'en': 'Gluten Sensitivity'},
    {'key': 'vegan', 'tr': 'Vegan/Vejetaryen', 'en': 'Vegan/Vegetarian'},
    {'key': 'lactose', 'tr': 'Laktoz İntoleransı', 'en': 'Lactose Intolerance'},
    {'key': 'allergen', 'tr': 'Alerjenler', 'en': 'Allergens'},
    {'key': 'pku', 'tr': 'Fenilketonüri (PKU)', 'en': 'Phenylketonuria (PKU)'},
    {'key': 'hypertension', 'tr': 'Yüksek Tansiyon', 'en': 'Hypertension'},
  ];

  @override
  void initState() {
    super.initState();
    healthRisks = {...widget.selectedHealth};
  }

  String t(String tr, String en) => widget.lang == 'tr' ? tr : en;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: .25),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(t('Dil Seçimi', 'Language'), style: const TextStyle(fontSize: 18)),
                      trailing: DropdownButton<String>(
                        value: widget.lang,
                        items: const [
                          DropdownMenuItem(value: 'tr', child: Text('Türkçe')),
                          DropdownMenuItem(value: 'en', child: Text('English')),
                        ],
                        onChanged: (val) => widget.onLangChange(val ?? 'tr'),
                      ),
                    ),
                    const Divider(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        t('Sağlık Modları', 'Health Preferences'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    ...allRisks.map((risk) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: CheckboxListTile(
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: healthRisks.contains(risk['key']),
                            title: Text(t(risk['tr']!, risk['en']!), style: const TextStyle(fontSize: 16)),
                            activeColor: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            tileColor: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.12),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  healthRisks.add(risk['key']!);
                                } else {
                                  healthRisks.remove(risk['key']!);
                                }
                              });
                              widget.onHealthChange(healthRisks.toList());
                            },
                          ),
                        )),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: .2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Theme.of(context).colorScheme.secondaryContainer, width: 1),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.privacy_tip, color: Theme.of(context).colorScheme.secondary, size: 28),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              t(
                                'Gizlilik: Fotoğraflar ve analizler sadece cihazınızda tutulur. Hiçbir veri buluta iletilmez.',
                                'Privacy: Photos and analyses are stored only on your device. No data is sent to the cloud.',
                              ),
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
