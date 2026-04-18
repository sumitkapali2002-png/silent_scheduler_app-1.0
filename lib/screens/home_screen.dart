import 'dart:async';
import 'package:flutter/material.dart';
import '../models/schedule.dart';
import '../services/localization_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';
import '../widgets/schedule_card.dart';
import 'settings_screen.dart';
import 'world_clock_screen.dart';

class HomeScreen extends StatefulWidget {
  final Future<void> Function(String) onLanguageChanged;

  const HomeScreen({
    super.key,
    required this.onLanguageChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Schedule> schedules = [];
  int _selectedIndex = 0;
  Timer? _scheduleTimer;
  final Set<String> _triggeredToday = {};

  @override
  void initState() {
    super.initState();
    loadSchedules();
    startScheduleChecker();
  }

  @override
  void dispose() {
    _scheduleTimer?.cancel();
    super.dispose();
  }

  Future<void> loadSchedules() async {
    final data = await StorageService.loadSchedules();
    if (mounted) {
      setState(() {
        schedules = data;
      });
    }
  }

  Future<void> saveSchedules() async {
    await StorageService.saveSchedules(schedules);
  }

  void startScheduleChecker() {
    _scheduleTimer?.cancel();
    _scheduleTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (!mounted) return;

      final now = DateTime.now();
      final minuteKey =
          '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}';

      for (final schedule in schedules) {
        final key =
            '$minuteKey-${schedule.title}-${schedule.startHour}-${schedule.startMinute}';

        if (_triggeredToday.contains(key)) continue;

        if (now.hour == schedule.startHour &&
            now.minute == schedule.startMinute) {
          _triggeredToday.add(key);

          await NotificationService.showCustomNotification(
            title: 'Schedule: ${schedule.title}',
            body: 'Mode: ${schedule.mode} is starting now',
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${schedule.title} started now')),
            );
          }
        }
      }
    });
  }

  Future<void> showAddScheduleDialog() async {
    final titleController = TextEditingController();
    TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 10, minute: 0);
    String selectedMode = 'Silent';
    double alertBefore = 0;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(LocalizationService.text('add_schedule')),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: LocalizationService.text('title'),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        '${LocalizationService.text('start_time')}: ${startTime.format(context)}',
                      ),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: startTime,
                        );
                        if (picked != null) {
                          setDialogState(() {
                            startTime = picked;
                          });
                        }
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        '${LocalizationService.text('end_time')}: ${endTime.format(context)}',
                      ),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: endTime,
                        );
                        if (picked != null) {
                          setDialogState(() {
                            endTime = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedMode,
                      decoration: InputDecoration(
                        labelText: LocalizationService.text('mode'),
                        border: const OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Silent', child: Text('Silent')),
                        DropdownMenuItem(value: 'Vibrate', child: Text('Vibrate')),
                        DropdownMenuItem(value: 'Normal', child: Text('Normal')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedMode = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '${LocalizationService.text('alert_before')}: ${alertBefore.toInt()} min',
                    ),
                    Slider(
                      value: alertBefore,
                      min: 0,
                      max: 60,
                      divisions: 12,
                      onChanged: (value) {
                        setDialogState(() {
                          alertBefore = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(LocalizationService.text('cancel')),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a title')),
                      );
                      return;
                    }

                    final schedule = Schedule(
                      title: titleController.text.trim(),
                      startHour: startTime.hour,
                      startMinute: startTime.minute,
                      endHour: endTime.hour,
                      endMinute: endTime.minute,
                      mode: selectedMode,
                      alertBeforeMinutes: alertBefore.toInt(),
                    );

                    setState(() {
                      schedules.add(schedule);
                    });

                    await saveSchedules();

                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Schedule saved')),
                      );
                    }
                  },
                  child: Text(LocalizationService.text('save')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildHomePage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton<String>(
            value: LocalizationService.currentLanguageCode,
            style: const TextStyle(fontSize: 24, color: Colors.black),
            underline: Container(
              height: 1,
              color: Colors.grey.shade300,
            ),
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'ne', child: Text('नेपाली')),
            ],
            onChanged: (value) async {
              if (value != null) {
                await widget.onLanguageChanged(value);
                if (mounted) {
                  setState(() {});
                }
              }
            },
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 18,
            runSpacing: 18,
            children: [
              SizedBox(
                width: 290,
                height: 74,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    backgroundColor: const Color(0xFFE9E6EE),
                    foregroundColor: const Color(0xFF5D6294),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                    ),
                  ),
                  onPressed: () async {
                    await NotificationService.showTestNotification();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Test notification sent')),
                      );
                    }
                  },
                  child: const Text(
                    'Test Notification',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                height: 74,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF5D6294),
                    side: const BorderSide(color: Colors.black45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                    ),
                  ),
                  onPressed: () async {
                    await NotificationService.clearAllNotifications();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Notifications cleared')),
                      );
                    }
                  },
                  child: const Text(
                    'Clear Notification',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Expanded(
            child: schedules.isEmpty
                ? Center(
              child: Text(
                LocalizationService.text('no_schedules'),
                style: const TextStyle(fontSize: 20),
              ),
            )
                : ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                return ScheduleCard(
                  schedule: schedules[index],
                  onDelete: () async {
                    setState(() {
                      schedules.removeAt(index);
                    });
                    await saveSchedules();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_selectedIndex == 0) {
      return _buildHomePage();
    } else if (_selectedIndex == 1) {
      return const WorldClockScreen();
    } else {
      return SettingsScreen(
        isEnglish: LocalizationService.currentLanguageCode == 'en',
        onLanguageChanged: widget.onLanguageChanged,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final titles = [
      LocalizationService.text('app_title'),
      LocalizationService.text('world_clock'),
      LocalizationService.text('settings'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[_selectedIndex],
          style: const TextStyle(fontSize: 28),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _buildBody(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        backgroundColor: const Color(0xFFD9DBF6),
        foregroundColor: const Color(0xFF4D518C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
        onPressed: showAddScheduleDialog,
        child: const Icon(Icons.add, size: 38),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF5D6294),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontSize: 16),
        unselectedLabelStyle: const TextStyle(fontSize: 16),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Text('🏠', style: TextStyle(fontSize: 34)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Text('🕒', style: TextStyle(fontSize: 34)),
            label: 'Clock',
          ),
          BottomNavigationBarItem(
            icon: Text('⚙️', style: TextStyle(fontSize: 34)),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}