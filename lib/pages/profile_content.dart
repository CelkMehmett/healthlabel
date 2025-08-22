import 'package:flutter/material.dart';
import '../state/app_state.dart';

class ProfileContent extends StatefulWidget {
  final String lang;
  const ProfileContent({super.key, required this.lang});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  late bool diabetes;
  late bool gluten;
  late bool peanut;

  String t(String tr, String en, [String de = '', String fr = '']) {
    switch (widget.lang) {
      case 'tr':
        return tr;
      case 'en':
        return en;
      case 'de':
        return de.isNotEmpty ? de : en;
      case 'fr':
        return fr.isNotEmpty ? fr : en;
      default:
        return en;
    }
  }

  @override
  void initState() {
    super.initState();
    final p = AppState.I.prefs.value;
    diabetes = p.diabetes;
    gluten = p.gluten;
    peanut = p.peanut;
  }

  Future<void> _save() async {
    final p = AppState.I.prefs.value
      ..diabetes = diabetes
      ..gluten = gluten
      ..peanut = peanut;
    await p.save();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t('Kaydedildi', 'Saved'))),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          t('Sağlık Tercihleri', 'Health Preferences'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: Text(t('Diyabet', 'Diabetes')),
          value: diabetes,
          onChanged: (v) => setState(() => diabetes = v),
        ),
        SwitchListTile(
          title: Text(t('Gluten Hassasiyeti', 'Gluten Intolerance')),
          value: gluten,
          onChanged: (v) => setState(() => gluten = v),
        ),
        SwitchListTile(
          title: Text(t('Fıstık Alerjisi', 'Peanut Allergy')),
          value: peanut,
          onChanged: (v) => setState(() => peanut = v),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('Son 30 analiz özeti', 'Last 30 analyses')),
                const SizedBox(height: 10),
                const LinearProgressIndicator(value: 0.65),
                const SizedBox(height: 4),
                Text(t('%65 güvenli ürün', '65% safe products')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _save,
          child: Text(t('Kaydet', 'Save')),
        ),
      ],
    );
  }
}
