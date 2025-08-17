import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/boq_item.dart';
import '../utils/formulas.dart';

class BoqProvider extends ChangeNotifier {
  static const _storageKey = 'boq_rows_v1';
  final List<BoqItem> _rows = [];

  List<BoqItem> get rows => List.unmodifiable(_rows);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      final list = (json.decode(raw) as List<dynamic>)
          .map((e) => BoqItem.fromMap(e as Map<String, dynamic>))
          .toList();
      _rows..clear()..addAll(list);
    }
    notifyListeners();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = json.encode(_rows.map((e) => e.toMap()).toList());
    await prefs.setString(_storageKey, raw);
  }

  Future<void> add(BoqItem item) async {
    _rows.insert(0, item);
    await save();
    notifyListeners();
  }

  Future<void> remove(String id) async {
    _rows.removeWhere((e) => e.id == id);
    await save();
    notifyListeners();
  }

  Future<void> clear() async {
    _rows.clear();
    await save();
    notifyListeners();
  }

  double get grandTotal => _rows.fold(0, (p, e) => p + Formulas.lineTotal(e));
}
