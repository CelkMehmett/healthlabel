import 'package:flutter/material.dart';
import '../main.dart';
import '../services/settings_service.dart';

class SettingsContent extends StatefulWidget {
  const SettingsContent({super.key});

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  String get _lang => appLang.value.toLowerCase();
  bool _dark = false;

  // State'e ekleyin:
  bool hideGluten = false;
  bool hideLactose = false;
  bool hideNonVegan = false;
  bool hideNut = false;
  bool hideEgg = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    String t(String tr, String en, [String de = '', String fr = '']) {
      switch (_lang) {
        case 'tr': return tr;
        case 'en': return en;
        case 'de': return de.isNotEmpty ? de : en;
        case 'fr': return fr.isNotEmpty ? fr : en;
        default: return en;
      }
    }
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(t('Ayarlar', 'Settings', 'Einstellungen', 'Paramètres'), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Row(children: [
          Text(t('Dil:', 'Language:', 'Sprache:', 'Langue:')), const SizedBox(width: 8),
          DropdownButton<String>(
            value: _lang.toUpperCase(),
            items: const [
              DropdownMenuItem(value: 'TR', child: Text('Türkçe')),
              DropdownMenuItem(value: 'EN', child: Text('English')),
              DropdownMenuItem(value: 'DE', child: Text('Deutsch')),
              DropdownMenuItem(value: 'FR', child: Text('Français')),
            ],
            onChanged: (v) {
              if (v != null) {
                appLang.value = v.toLowerCase();
                setState(() {});
              }
            },
          ),
        ]),
        SwitchListTile(title: Text(t('Koyu Tema', 'Dark Theme', 'Dunkles Thema', 'Thème sombre')), value: _dark, onChanged: (v) => setState(() => _dark = v)),
        const SizedBox(height: 16),
        
        // Privacy Policy Section
        ListTile(
          leading: const Icon(Icons.lock_outline),
          title: Text(t('Gizlilik Politikası', 'Privacy Policy', 'Datenschutz', 'Politique de confidentialité')),
          subtitle: Text(t('Gizlilik politikamızı görüntüleyin', 'View our privacy policy', 'Unsere Datenschutzrichtlinie anzeigen', 'Voir notre politique de confidentialité'), style: TextStyle(color: cs.onSurfaceVariant)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => Navigator.pushNamed(context, '/privacy'),
        ),
        
        ListTile(
          leading: const Icon(Icons.shield_outlined),
          title: Text(t('Veri Güvenliği', 'Data Security', 'Datensicherheit', 'Sécurité des données')),
          subtitle: Text(
            t(
              'Tüm veriler yalnızca cihazda saklanır.',
              'All data is stored only on device.',
              'Alle Daten werden nur auf dem Gerät gespeichert.',
              'Toutes les données sont uniquement stockées sur l\'appareil.'
            ),
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
        ),
        
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: OutlinedButton(onPressed: () {/* TODO: dışa aktar */}, child: Text(t('Verileri dışa aktar', 'Export data', 'Daten exportieren', 'Exporter les données')))),
          const SizedBox(width: 12),
          Expanded(child: FilledButton(
            onPressed: () { 
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(t('Tüm geçmiş silindi', 'All history deleted', 'Alle Verlauf gelöscht', 'Historique supprimé')))
              ); 
            },
            child: Text(t('Tüm verileri sil', 'Delete all data', 'Alle Daten löschen', 'Supprimer toutes les données')),
          )),
        ]),
        const SizedBox(height: 16),
        Text(t('Sağlık Riskleri ve Filtreler', 'Health Risks & Filters', 'Gesundheitsrisiken & Filter', 'Risques de santé & filtres'), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        CheckboxListTile(
          title: Text(t('Gluten içerenleri gösterme', 'Hide gluten products', 'Glutenprodukte ausblenden', 'Masquer les produits contenant du gluten')),
          value: hideGluten,
          onChanged: (v) async { setState(() => hideGluten = v ?? false); await SettingsService.saveHideGluten(hideGluten);},
        ),
        CheckboxListTile(
          title: Text(t('Laktoz içerenleri gösterme', 'Hide lactose products', 'Laktoseprodukte ausblenden', 'Masquer les produits contenant du lactose')),
          value: hideLactose,
          onChanged: (v) => setState(() => hideLactose = v ?? false),
        ),
        CheckboxListTile(
          title: Text(t('Vegan olmayanları gösterme', 'Hide non-vegan products', 'Nicht-vegane Produkte ausblenden', 'Masquer les produits non vegan')),
          value: hideNonVegan,
          onChanged: (v) => setState(() => hideNonVegan = v ?? false),
        ),
        CheckboxListTile(
          title: Text(t('Fındık içerenleri gösterme', 'Hide nut products', 'Nussprodukte ausblenden', 'Masquer les produits contenant des noix')),
          value: hideNut,
          onChanged: (v) async { setState(() => hideNut = v ?? false); await SettingsService.saveHideNut(hideNut);},
        ),
        CheckboxListTile(
          title: Text(t('Yumurta içerenleri gösterme', 'Hide egg products', 'Eiprodukte ausblenden', 'Masquer les produits contenant des œufs')),
          value: hideEgg,
          onChanged: (v) async { setState(() => hideEgg = v ?? false); await SettingsService.saveHideEgg(hideEgg);},
        ),
      ],
    );
  }
}