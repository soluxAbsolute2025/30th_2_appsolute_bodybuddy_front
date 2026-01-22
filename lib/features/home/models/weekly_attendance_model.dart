enum AttendanceStatus { success, none }

AttendanceStatus attendanceStatusFrom(String v) {
  switch (v) {
    case 'SUCCESS':
      return AttendanceStatus.success;
    case 'NONE':
    default:
      return AttendanceStatus.none;
  }
}

AttendanceStatus attendanceStatusFromChecked(bool checked) {
  return checked ? AttendanceStatus.success : AttendanceStatus.none;
}

DateTime parseDateOnly(String s) {
  final parts = s.split('-').map(int.parse).toList();
  return DateTime.utc(parts[0], parts[1], parts[2]).add(const Duration(hours: 9));
}

class WeeklyAttendance {
  final DateTime date;
  final AttendanceStatus status;

  const WeeklyAttendance({
    required this.date,
    required this.status,
  });

  factory WeeklyAttendance.fromWeekJson(Map<String, dynamic> json) {
    return WeeklyAttendance(
      date: parseDateOnly(json['date'] as String),
      status: attendanceStatusFrom(json['status'] as String),
    );
  }

  factory WeeklyAttendance.fromAttendanceJson(Map<String, dynamic> json) {
    return WeeklyAttendance(
      date: parseDateOnly(json['date'] as String),
      status: attendanceStatusFromChecked(json['checked'] as bool),
    );
  }
}
