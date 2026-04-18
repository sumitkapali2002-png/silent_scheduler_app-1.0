import 'package:flutter/material.dart';
import '../models/schedule.dart';

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;
  final VoidCallback onDelete;

  const ScheduleCard({
    super.key,
    required this.schedule,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final modeLetter = schedule.mode.isNotEmpty ? schedule.mode[0] : 'S';

    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: const Color(0xFFDCDDF5),
              child: Text(
                modeLetter,
                style: const TextStyle(
                  fontSize: 22,
                  color: Color(0xFF4D518C),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${schedule.startTimeFormatted} - ${schedule.endTimeFormatted}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Mode: ${schedule.mode} | Alert: ${schedule.alertBeforeMinutes} min\nbefore',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
                size: 34,
              ),
            ),
          ],
        ),
      ),
    );
  }
}