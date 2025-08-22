import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_item.dart';

class HistoryRepository {
  HistoryRepository._();
  static final HistoryRepository I = HistoryRepository._();

  static const _kKey = 'history_items';

  final ValueNotifier<List<HistoryItem>> items = ValueNotifier<List<HistoryItem>>([]);

  Future<void> init() async {
    final sp = await SharedPreferences.getInstance();
    final list = sp.getStringList(_kKey) ?? const [];
    final parsed = <HistoryItem>[];
    for (final s in list) {
      try {
        parsed.add(HistoryItem.fromJson(json.decode(s) as Map<String, dynamic>));
      } catch (_) {}
    }
    items.value = parsed;
  }

  Future<void> _persist() async {
    final sp = await SharedPreferences.getInstance();
    final list = items.value.map((e) => json.encode(e.toJson())).toList();
    await sp.setStringList(_kKey, list);
  }

  Future<void> add(HistoryItem item) async {
    items.value = [...items.value, item];
    await _persist();
  }

  Future<void> remove(String id) async {
    items.value = items.value.where((e) => e.id != id).toList();
    await _persist();
  }

  Future<void> clear() async {
    items.value = [];
    await _persist();
  }
}
