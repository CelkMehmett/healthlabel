import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _kLang = 'settings_lang';
  static const _kDark = 'settings_dark';
  static const _kHideGluten = 'settings_hide_gluten';
  static const _kHideNut = 'settings_hide_nut';
  static const _kHideEgg = 'settings_hide_egg';

  static Future<String> loadLang({String fallback = 'tr'}) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kLang) ?? fallback;
  }

  static Future<void> saveLang(String lang) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kLang, lang);
  }

  static Future<bool> loadDark() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_kDark) ?? false;
  }

  static Future<void> saveDark(bool v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kDark, v);
  }

  static Future<bool> loadHideGluten() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_kHideGluten) ?? false;
  }

  static Future<void> saveHideGluten(bool v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kHideGluten, v);
  }

  static Future<bool> loadHideNut() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_kHideNut) ?? false;
  }

  static Future<void> saveHideNut(bool v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kHideNut, v);
  }

  static Future<bool> loadHideEgg() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_kHideEgg) ?? false;
  }

  static Future<void> saveHideEgg(bool v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kHideEgg, v);
  }
}
