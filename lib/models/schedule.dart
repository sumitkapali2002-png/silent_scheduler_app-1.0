class Schedule {
  final String title;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final String mode;
  final int alertBeforeMinutes;

  Schedule({
    required this.title,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.mode,
    required this.alertBeforeMinutes,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'startHour': startHour,
      'startMinute': startMinute,
      'endHour': endHour,
      'endMinute': endMinute,
      'mode': mode,
      'alertBeforeMinutes': alertBeforeMinutes,
    };
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      title: json['title'] ?? '',
      startHour: json['startHour'] ?? 0,
      startMinute: json['startMinute'] ?? 0,
      endHour: json['endHour'] ?? 0,
      endMinute: json['endMinute'] ?? 0,
      mode: json['mode'] ?? 'Silent',
      alertBeforeMinutes: json['alertBeforeMinutes'] ?? 0,
    );
  }

  String get startTimeFormatted =>
      '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}';

  String get endTimeFormatted =>
      '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';
}