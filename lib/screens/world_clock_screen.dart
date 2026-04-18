import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorldClockScreen extends StatefulWidget {
  const WorldClockScreen({super.key});

  @override
  State<WorldClockScreen> createState() => _WorldClockScreenState();
}

class _WorldClockScreenState extends State<WorldClockScreen> {
  late Timer _timer;
  DateTime now = DateTime.now().toUtc();

  final List<Map<String, dynamic>> zones = [
    {'city': 'Sydney', 'offsetHours': 10, 'offsetMinutes': 0},
    {'city': 'Kathmandu', 'offsetHours': 5, 'offsetMinutes': 45},
    {'city': 'London', 'offsetHours': 0, 'offsetMinutes': 0},
    {'city': 'New York', 'offsetHours': -4, 'offsetMinutes': 0},
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          now = DateTime.now().toUtc();
        });
      }
    });
  }

  DateTime getCityTime(int hours, int minutes) {
    return now.add(Duration(hours: hours, minutes: minutes));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  IconData _iconForCity(String city) {
    switch (city) {
      case 'Sydney':
        return Icons.sunny;
      case 'Kathmandu':
        return Icons.temple_hindu;
      case 'London':
        return Icons.location_city;
      case 'New York':
        return Icons.location_city;
      default:
        return Icons.access_time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
      itemCount: zones.length,
      itemBuilder: (context, index) {
        final zone = zones[index];
        final cityTime =
        getCityTime(zone['offsetHours'], zone['offsetMinutes']);

        return Card(
          margin: const EdgeInsets.only(bottom: 18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Row(
              children: [
                Icon(
                  _iconForCity(zone['city']),
                  size: 42,
                  color: Colors.black54,
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        zone['city'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        DateFormat('EEE, dd MMM yyyy').format(cityTime),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Text(
                  DateFormat('hh:mm:ss a').format(cityTime),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}