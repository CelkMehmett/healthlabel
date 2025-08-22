import 'package:flutter/material.dart';
import '../state/app_state.dart';

class ProfilePage extends StatefulWidget {
  static const route = '/profile';
  final String lang;
  const ProfilePage({super.key, required this.lang});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserPrefs prefs;

  @override
  void initState() {
    super.initState();
    prefs = AppState.I.prefs.value;
  }

  Widget _switch(String label, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: (v) => setState(() => onChanged(v)),
    );
  }

  void _save() async {
    await prefs.save();
    AppState.I.prefs.value = prefs;
    String message = widget.lang == 'tr' ? "Tercihler kaydedildi" : widget.lang == 'de' ? "Einstellungen gespeichert" : widget.lang == 'fr' ? "Préférences enregistrées" : "Preferences saved";
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    String t(String tr, String en, [String de = '', String fr = '']) {
      switch (widget.lang) {
        case 'tr': return tr;
        case 'en': return en;
        case 'de': return de.isNotEmpty ? de : en;
        case 'fr': return fr.isNotEmpty ? fr : en;
        default: return en;
      }
    }
    
    return Scaffold(
      appBar: AppBar(title: Text(t("Sağlık Tercihleri", "Health Preferences", "Gesundheitspräferenzen", "Préférences de santé"))),
      body: ListView(
        children: [
          _switch(t("Diyabet", "Diabetes", "Diabetes", "Diabète"), prefs.diabetes, (v) => prefs.diabetes = v),
          _switch(t("Gluten", "Gluten", "Gluten", "Gluten"), prefs.gluten, (v) => prefs.gluten = v),
          _switch(t("Yer fıstığı", "Peanut", "Erdnuss", "Cacahuète"), prefs.peanut, (v) => prefs.peanut = v),
          _switch(t("Laktoz", "Lactose", "Laktose", "Lactose"), prefs.lactose, (v) => prefs.lactose = v),
          _switch(t("Yumurta", "Egg", "Ei", "Œuf"), prefs.egg, (v) => prefs.egg = v),
          _switch(t("Soya", "Soy", "Soja", "Soja"), prefs.soy, (v) => prefs.soy = v),
          _switch(t("Susam", "Sesame", "Sesam", "Sésame"), prefs.sesame, (v) => prefs.sesame = v),
          _switch(t("Kabuklu Deniz Ürünleri", "Shellfish", "Schalentiere", "Fruits de mer"), prefs.shellfish, (v) => prefs.shellfish = v),
          _switch(t("Fındık / Kuruyemiş", "Nuts", "Nüsse", "Noix"), prefs.nuts, (v) => prefs.nuts = v),
          _switch(t("Kafein", "Caffeine", "Koffein", "Caféine"), prefs.caffeine, (v) => prefs.caffeine = v),
          _switch(t("MSG", "MSG", "MSG", "MSG"), prefs.msg, (v) => prefs.msg = v),
          _switch(t("Renklendiriciler", "Colorants", "Farbstoffe", "Colorants"), prefs.colorants, (v) => prefs.colorants = v),
          _switch(t("Katkı Maddeleri", "Additives", "Zusatzstoffe", "Additifs"), prefs.additives, (v) => prefs.additives = v),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: _save,
              child: Text(t("Kaydet", "Save", "Speichern", "Enregistrer")),
            ),
          ),
        ],
      ),
    );
  }
}