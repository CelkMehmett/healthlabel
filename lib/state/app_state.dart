import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  bool diabetes;
  bool gluten;
  bool peanut;
  bool lactose;
  bool egg;
  bool soy;
  bool sesame;
  bool shellfish;
  bool nuts;
  bool caffeine;
  bool msg;
  bool colorants;
  bool additives;

  UserPrefs({
    this.diabetes = false,
    this.gluten = false,
    this.peanut = false,
    this.lactose = false,
    this.egg = false,
    this.soy = false,
    this.sesame = false,
    this.shellfish = false,
    this.nuts = false,
    this.caffeine = false,
    this.msg = false,
    this.colorants = false,
    this.additives = false,
  });

  static const _kBoxPrefix = 'prefs_';

  static Future<UserPrefs> load() async {
    final sp = await SharedPreferences.getInstance();
    return UserPrefs(
      diabetes: sp.getBool('${_kBoxPrefix}diabetes') ?? false,
      gluten: sp.getBool('${_kBoxPrefix}gluten') ?? false,
      peanut: sp.getBool('${_kBoxPrefix}peanut') ?? false,
      lactose: sp.getBool('${_kBoxPrefix}lactose') ?? false,
      egg: sp.getBool('${_kBoxPrefix}egg') ?? false,
      soy: sp.getBool('${_kBoxPrefix}soy') ?? false,
      sesame: sp.getBool('${_kBoxPrefix}sesame') ?? false,
      shellfish: sp.getBool('${_kBoxPrefix}shellfish') ?? false,
      nuts: sp.getBool('${_kBoxPrefix}nuts') ?? false,
      caffeine: sp.getBool('${_kBoxPrefix}caffeine') ?? false,
      msg: sp.getBool('${_kBoxPrefix}msg') ?? false,
      colorants: sp.getBool('${_kBoxPrefix}colorants') ?? false,
      additives: sp.getBool('${_kBoxPrefix}additives') ?? false,
    );
  }

  Future<void> save() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool('${_kBoxPrefix}diabetes', diabetes);
    await sp.setBool('${_kBoxPrefix}gluten', gluten);
    await sp.setBool('${_kBoxPrefix}peanut', peanut);
    await sp.setBool('${_kBoxPrefix}lactose', lactose);
    await sp.setBool('${_kBoxPrefix}egg', egg);
    await sp.setBool('${_kBoxPrefix}soy', soy);
    await sp.setBool('${_kBoxPrefix}sesame', sesame);
    await sp.setBool('${_kBoxPrefix}shellfish', shellfish);
    await sp.setBool('${_kBoxPrefix}nuts', nuts);
    await sp.setBool('${_kBoxPrefix}caffeine', caffeine);
    await sp.setBool('${_kBoxPrefix}msg', msg);
    await sp.setBool('${_kBoxPrefix}colorants', colorants);
    await sp.setBool('${_kBoxPrefix}additives', additives);
  }
}

class AppState {
  AppState._();
  static final AppState I = AppState._();
  final ValueNotifier<UserPrefs> prefs = ValueNotifier(UserPrefs());

  Future<void> init() async {
    prefs.value = await UserPrefs.load();
  }
}
