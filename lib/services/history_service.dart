import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_session.dart';

class HistoryService {
  static const _key = 'workout_history_v1';

  static Future<List<WorkoutSession>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw
        .map((s) => WorkoutSession.fromJson(jsonDecode(s)))
        .toList()
        .reversed
        .toList();
  }

  static Future<void> save(WorkoutSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    raw.add(jsonEncode(session.toJson()));
    // Keep max 100 sessions so storage stays reasonable
    if (raw.length > 100) raw.removeAt(0);
    await prefs.setStringList(_key, raw);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
