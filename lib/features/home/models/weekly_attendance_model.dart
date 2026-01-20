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

class WeeklyAttendance {
  final DateTime date;
  final AttendanceStatus status;

  const WeeklyAttendance({
    required this.date,
    required this.status,
  });

  factory WeeklyAttendance.fromJson(Map<String, dynamic> json) {
    return WeeklyAttendance(
      date: DateTime.parse(json['date'] as String),
      status: attendanceStatusFrom(json['status'] as String),
    );
  }
}
