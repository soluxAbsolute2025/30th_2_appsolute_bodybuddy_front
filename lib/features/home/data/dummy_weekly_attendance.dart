import '../models/weekly_attendance_model.dart';

final dummyWeeklyAttendance = [
  WeeklyAttendance(
    date: DateTime(2025, 12, 29),
    status: AttendanceStatus.success,
  ),
  WeeklyAttendance(
    date: DateTime(2025, 12, 30),
    status: AttendanceStatus.success,
  ),
  WeeklyAttendance(
    date: DateTime(2025, 12, 31),
    status: AttendanceStatus.none,
  ),
  WeeklyAttendance(
    date: DateTime(2026, 01, 01),
    status: AttendanceStatus.success,
  ),
  WeeklyAttendance(
    date: DateTime(2026, 01, 02),
    status: AttendanceStatus.none,
  ),
  WeeklyAttendance(
    date: DateTime(2026, 01, 03),
    status: AttendanceStatus.none,
  ),
  WeeklyAttendance(
    date: DateTime(2026, 01, 04),
    status: AttendanceStatus.none,
  ),
];
