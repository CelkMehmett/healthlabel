import 'package:flutter/material.dart';
import '../pages/home_content.dart';
import '../../main.dart';

class HomeScreen extends StatefulWidget {
  final String lang;
  final List<String> selectedHealth;
  final VoidCallback? onOpenSettings;

  const HomeScreen({
    super.key,
    required this.lang,
    required this.selectedHealth,
    this.onOpenSettings,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ValueListenableBuilder<String>(
      valueListenable: appLang,
      builder: (context, lang, _) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: _index == 0
                  ? HomeContent(lang: lang)
                  : const SizedBox.shrink(),
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) {
              setState(() => _index = i);
              if (i == 1) Navigator.pushNamed(context, '/history');
              if (i == 2) Navigator.pushNamed(context, '/profile');
              if (i == 3) {
                if (widget.onOpenSettings != null) {
                  widget.onOpenSettings!();
                } else {
                  Navigator.pushNamed(context, '/settings');
                }
              }
            },
            destinations: [
              NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: cs.primary), label: lang == 'tr' ? 'Ana' : lang == 'de' ? 'Startseite' : lang == 'fr' ? 'Accueil' : 'Home'),
              NavigationDestination(icon: const Icon(Icons.history), label: lang == 'tr' ? 'Geçmiş' : lang == 'de' ? 'Verlauf' : lang == 'fr' ? 'Historique' : 'History'),
              NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: cs.primary), label: lang == 'tr' ? 'Profil' : lang == 'de' ? 'Profil' : lang == 'fr' ? 'Profil' : 'Profile'),
              NavigationDestination(icon: const Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings, color: cs.primary), label: lang == 'tr' ? 'Ayarlar' : lang == 'de' ? 'Einstellungen' : lang == 'fr' ? 'Paramètres' : 'Settings'),
            ],
          ),
        );
      },
    );
  }
}