import 'package:flutter/material.dart';
import '../models/weekly_attendance_model.dart';
import '../api/attendance_api.dart';

class AttendanceWeekStrip extends StatefulWidget {
  const AttendanceWeekStrip({super.key});

  @override
  State<AttendanceWeekStrip> createState() => _AttendanceWeekStripState();
}

class _AttendanceWeekStripState extends State<AttendanceWeekStrip> {
  late Future<List<WeeklyAttendance>> _future;

  @override
  void initState() {
    super.initState();
    _future = AttendanceApi().fetchWeekly();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return FutureBuilder<List<WeeklyAttendance>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _loading();
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return _error();
        }

        final weeklyAttendance = snapshot.data!;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weeklyAttendance.map((attendance) {
              final isSuccess = attendance.status == AttendanceStatus.success;
              final isToday = _isSameDate(attendance.date, today);

              return GestureDetector(
                onTap: isToday && !isSuccess
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('퀴즈를 완료하면 출석 체크돼요!')),
                        );
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
                              style: const TextStyle(
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
      },
    );
  }

  Widget _loading() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const SizedBox(
        height: 60,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _error() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Expanded(child: Text('주간 출석을 불러오지 못했어요.')),
          TextButton(
            onPressed: () => setState(() {
              _future = AttendanceApi().fetchWeekly();
            }),
            child: const Text('재시도'),
          ),
        ],
      ),
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _weekday(DateTime date) {
    const days = ['월', '화', '수', '목', '금', '토', '일'];
    return days[date.weekday - 1];
  }
}
