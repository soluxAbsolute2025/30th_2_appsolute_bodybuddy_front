import 'package:flutter/material.dart';
import '../data/dummy_weekly_attendance.dart';
import '../models/weekly_attendance_model.dart';

class AttendanceWeekStrip extends StatefulWidget {
  const AttendanceWeekStrip({super.key});

  @override
  State<AttendanceWeekStrip> createState() => _AttendanceWeekStripState();
}

class _AttendanceWeekStripState extends State<AttendanceWeekStrip> {
  late List<WeeklyAttendance> weeklyAttendance;

  @override
  void initState() {
    super.initState();
    weeklyAttendance = List.from(dummyWeeklyAttendance);
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: weeklyAttendance.map((attendance) {
          final isSuccess =
              attendance.status == AttendanceStatus.success;

          final isToday = _isSameDate(attendance.date, today);

          return GestureDetector(
            onTap: isToday && !isSuccess
                ? () {
                    setState(() {
                      final index =
                          weeklyAttendance.indexOf(attendance);
                      weeklyAttendance[index] = WeeklyAttendance(
                        date: attendance.date,
                        status: AttendanceStatus.success,
                      );
                    });
                  }
                : null,
            child: Column(
              children: [
                Text(
                  _weekday(attendance.date),
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 12,
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                    color: isToday
                        ? const Color(0xFF000000)
                        : const Color(0xFF505050),
                  ),
                ),

                const SizedBox(height: 6),
                Container(
                  width: 35,
                  height: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF3F3F3),
                    border: isSuccess
                        ? Border.all(
                            color: const Color(0xFF1AEDB1),
                            width: 1.5,
                          )
                        : null,
                  ),
                  child: isSuccess
                      ? Image.asset(
                          'assets/home/bodybuddy_logo.png',
                          width: 20,
                          height: 20,
                        )
                      : Text(
                          '${attendance.date.day}',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 12,
                            fontWeight: FontWeight.w600, 
                            color: Color(0xFF000000),
                          ),
                        ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  String _weekday(DateTime date) {
    const days = ['월', '화', '수', '목', '금', '토', '일'];
    return days[date.weekday - 1];
  }
}
