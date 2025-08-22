import 'package:flutter/material.dart';

import 'pages/home_content.dart';
import 'pages/scan_page.dart';          // yeni: lang almıyor
import 'pages/analysis_page.dart';      // yeni: lang almıyor
import 'pages/history_detail_page.dart';
import 'pages/history_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'pages/privacy_policy_page.dart';
import 'models/history_item.dart';
import 'screens/splash_screen.dart';
import 'services/settings_service.dart';
import 'repository/history_repository.dart';
import 'state/app_state.dart';

// (opsiyonel) yeni eklediklerim için:
import 'pages/barcode_scan_page.dart';
import 'pages/live_ocr_page.dart';

final ValueNotifier<String> appLang = ValueNotifier('tr');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.I.init();
  await HistoryRepository.I.init();
  final lang = await SettingsService.loadLang(fallback: 'tr');
  appLang.value = lang;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Label Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2E7D32),
      ),
      routes: {
        // Splash ilk açılır
        '/': (context) => const SplashScreen(),

        // HomePage'i ayrı route olarak kullan (AŞAĞIDA HomePage.route = '/home')
        HomePage.route: (context) => const HomePage(),

        // ---- DÜZELTİLENLER ----
        // ScanPage & AnalysisPage artık 'route' static alanına ve 'lang' paramına ihtiyaç duymuyor
        '/scan': (_) => const ScanPage(),
        '/analysis': (_) => const AnalysisPage(),
        // -----------------------

        // Diğer sayfalar sende nasıl ise öyle kalsın (bunlar hâlâ lang alıyor olabilir)
        HistoryPage.route: (_) => const HistoryPage(lang: 'tr'),
        ProfilePage.route: (_) => ValueListenableBuilder<String>(
              valueListenable: appLang,
              builder: (context, lang, _) => ProfilePage(lang: lang),
            ),
        SettingsPage.route: (_) => ValueListenableBuilder<String>(
              valueListenable: appLang,
              builder: (context, lang, _) => SettingsPage(lang: lang),
            ),
        '/privacy': (_) => ValueListenableBuilder<String>(
              valueListenable: appLang,
              builder: (context, lang, _) => PrivacyPolicyPage(lang: lang),
            ),

        // (opsiyonel) yeni eklediklerim:
        '/barcode': (_) => const BarcodeScanPage(),
        '/live_ocr': (_) => const LiveOcrPage(),
      },

      // history detail dynamic (arg gerektirir)
      onGenerateRoute: (settings) {
        if (settings.name == HistoryDetailPage.route) {
          final item = settings.arguments as HistoryItem;
          return MaterialPageRoute(builder: (_) => HistoryDetailPage(item: item));
        }
        return null;
      },

      // Splash ile başla (Splash içinden '/home'a yönlendir)
      initialRoute: '/',
    );
  }
}

/// Basit bir shell: AppBar + HomeContent (alt nav yok)
class HomePage extends StatelessWidget {
  // ÖNEMLİ: Eskiden '/' idi, Splash ile çakışıyordu
  static const route = '/home';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: appLang,
      builder: (context, lang, _) {
        return Scaffold(
          body: HomeContent(lang: lang),
        );
      },
    );
  }
}

// (opsiyonel) Dilli alternatif Home - kullanmıyorsan silebilirsin
class _HomePageWithLang extends StatefulWidget {
  const _HomePageWithLang();

  @override
  State<_HomePageWithLang> createState() => _HomePageWithLangState();
}

class _HomePageWithLangState extends State<_HomePageWithLang> {
  String _lang = 'tr';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Label Scanner'),
        actions: [
          DropdownButton<String>(
            value: _lang,
            underline: const SizedBox(),
            icon: const Icon(Icons.language),
            items: const [
              DropdownMenuItem(value: 'tr', child: Text('Türkçe')),
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'de', child: Text('Deutsch')),
              DropdownMenuItem(value: 'fr', child: Text('Français')),
            ],
            onChanged: (v) async {
              if (v != null) {
                setState(() => _lang = v);
                appLang.value = v; // global dil durumunu güncelle
                await SettingsService.saveLang(v);
              }
            },
          ),
        ],
      ),
      body: HomeContent(lang: _lang),
    );
  }
}