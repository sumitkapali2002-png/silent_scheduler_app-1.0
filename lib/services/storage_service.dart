import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/schedule.dart';

class StorageService {
  static const String _scheduleKey = 'saved_schedules';

  static Future<void> saveSchedules(List<Schedule> schedules) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = schedules.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_scheduleKey, encoded);
  }

  static Future<List<Schedule>> loadSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_scheduleKey) ?? [];
    return saved.map((e) => Schedule.fromJson(jsonDecode(e))).toList();
  }
}