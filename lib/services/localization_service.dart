import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService {
  static const String _languageKey = 'selected_language';
  static String _currentLanguageCode = 'en';

  static String get currentLanguageCode => _currentLanguageCode;
  static Locale get currentLocale => Locale(_currentLanguageCode);

  static Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguageCode = prefs.getString(_languageKey) ?? 'en';
  }

  static Future<void> setLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguageCode = code;
    await prefs.setString(_languageKey, code);
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'Silent Scheduler',
      'settings': 'Settings',
      'language': 'Language',
      'world_clock': 'World Clock',
      'no_schedules': 'No schedules added yet',
      'add_schedule': 'Add Schedule',
      'title': 'Title',
      'start_time': 'Start Time',
      'end_time': 'End Time',
      'mode': 'Mode',
      'alert_before': 'Alert Before',
      'cancel': 'Cancel',
      'save': 'Save',
    },
    'ne': {
      'app_title': 'साइलेन्ट सेड्युलर',
      'settings': 'सेटिङ्स',
      'language': 'भाषा',
      'world_clock': 'विश्व घडी',
      'no_schedules': 'अहिलेसम्म कुनै तालिका थपिएको छैन',
      'add_schedule': 'तालिका थप्नुहोस्',
      'title': 'शीर्षक',
      'start_time': 'सुरु समय',
      'end_time': 'समाप्ति समय',
      'mode': 'मोड',
      'alert_before': 'अगाडि सूचना',
      'cancel': 'रद्द गर्नुहोस्',
      'save': 'सेभ गर्नुहोस्',
    },
  };

  static String text(String key) {
    return _localizedValues[_currentLanguageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }
}