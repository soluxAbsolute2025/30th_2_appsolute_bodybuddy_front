enum AttendanceStatus {
  success,
  none,
}

class WeeklyAttendance {
  final DateTime date;
  final AttendanceStatus status;

  WeeklyAttendance({
    required this.date,
    required this.status,
  });
}
