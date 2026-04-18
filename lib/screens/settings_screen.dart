import 'package:flutter/material.dart';
import '../services/localization_service.dart';

class SettingsScreen extends StatefulWidget {
  final bool isEnglish;
  final Future<void> Function(String) onLanguageChanged;

  const SettingsScreen({
    super.key,
    required this.isEnglish,
    required this.onLanguageChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String selectedLanguage;

  @override
  void initState() {
    super.initState();
    selectedLanguage = widget.isEnglish ? 'en' : 'ne';
  }

  Future<void> changeLanguage(String value) async {
    await widget.onLanguageChanged(value);
    if (mounted) {
      setState(() {
        selectedLanguage = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.language, size: 40),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      LocalizationService.text('language'),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              RadioListTile<String>(
                title: const Text(
                  'English',
                  style: TextStyle(fontSize: 20),
                ),
                value: 'en',
                groupValue: selectedLanguage,
                onChanged: (value) {
                  if (value != null) {
                    changeLanguage(value);
                  }
                },
              ),
              const SizedBox(height: 12),
              RadioListTile<String>(
                title: const Text(
                  'नेपाली',
                  style: TextStyle(fontSize: 20),
                ),
                value: 'ne',
                groupValue: selectedLanguage,
                onChanged: (value) {
                  if (value != null) {
                    changeLanguage(value);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}