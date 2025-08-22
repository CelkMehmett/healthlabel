import 'package:flutter/material.dart';
import 'settings_content.dart';

class SettingsPage extends StatelessWidget {
  static const route = '/settings';
  final String lang;
  const SettingsPage({super.key, required this.lang});

  @override
  Widget build(BuildContext context) {
    String title = lang == 'tr' ? 'Ayarlar' : lang == 'de' ? 'Einstellungen' : lang == 'fr' ? 'Paramètres' : 'Settings';
    return Scaffold(appBar: AppBar(title: Text(title)), body: const SettingsContent());
  }
}