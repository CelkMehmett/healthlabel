import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  final String lang;
  final ValueChanged<String> onNavigate;
  const NavDrawer({super.key, required this.lang, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  Icon(Icons.health_and_safety, size: 64, color: Colors.green[600]),
                  const SizedBox(height: 8),
                  Text(
                    lang == 'tr' ? 'Etiket Sağlık Analiz' : 'Label Health Scan',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(lang == 'tr' ? 'Ana Sayfa' : 'Home'),
              onTap: () => onNavigate('home'),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: Text(lang == 'tr' ? 'Geçmiş' : 'History'),
              onTap: () => onNavigate('history'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(lang == 'tr' ? 'Ayarlar' : 'Settings'),
              onTap: () => onNavigate('settings'),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(lang == 'tr' ? 'Profil' : 'Profile'),
              onTap: () => onNavigate('profile'),
            ),
          ],
        ),
      ),
    );
  }
}