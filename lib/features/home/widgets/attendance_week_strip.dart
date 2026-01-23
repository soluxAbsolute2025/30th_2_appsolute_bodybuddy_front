import 'package:flutter/material.dart';
import '../models/weekly_attendance_model.dart';
import '../api/attendance_api.dart';
import '../../../common/kst_time.dart';

class AttendanceWeekStrip extends StatefulWidget {
  final bool forceStampToday;

  const AttendanceWeekStrip({super.key, this.forceStampToday = false});

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

  void refresh() {
    setState(() {
      _future = AttendanceApi().fetchWeekly();
    });
  }

  // ✅ 서버 DateTime을 "KST dateOnly"로 정규화
  DateTime _kstDateOnly(DateTime dt) {
    final utc = dt.toUtc();
    final kst = utc.add(const Duration(hours: 9));
    return DateTime(kst.year, kst.month, kst.day);
  }

  String _ymd(DateTime dt) {
    final d = _kstDateOnly(dt);
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  @override
  Widget build(BuildContext context) {
    final today = dateOnlyKST();
    final todayIndex = today.weekday - 1;

    final monday = today.subtract(Duration(days: today.weekday - 1));
    DateTime dateOfIndex(int idx) => monday.add(Duration(days: idx));

    return FutureBuilder<List<WeeklyAttendance>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return _loading();
        if (snapshot.hasError || !snapshot.hasData) return _error();

        final weekly = snapshot.data!;

        // ✅ 서버 응답을 "KST yyyy-mm-dd" 키로 매핑
        final stampedByYmd = <String, bool>{};
        for (final w in weekly) {
          stampedByYmd[_ymd(w.date)] = (w.status == AttendanceStatus.success);
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (idx) {
              final date = dateOfIndex(idx);
              final isToday = idx == todayIndex;

              final key = _ymd(date);
              final isStampedFromServer = stampedByYmd[key] == true;
              final isStamped =
                  isStampedFromServer || (widget.forceStampToday && isToday);

              return GestureDetector(
                onTap: isToday && !isStamped
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('퀴즈를 완료하면 출석 체크돼요!')),
                        );
                      }
                    : null,
                child: Column(
                  children: [
                    Text(
                      _weekday(date),
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
                        border: isStamped
                            ? Border.all(
                                color: const Color(0xFF1AEDB1),
                                width: 1.5,
                              )
                            : null,
                      ),
                      child: isStamped
                          ? Image.asset(
                              'assets/home/bodybuddy_logo.png',
                              width: 20,
                              height: 20,
                            )
                          : Text(
                              '${date.day}',
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
            }),
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

  String _weekday(DateTime date) {
    const days = ['월', '화', '수', '목', '금', '토', '일'];
    return days[date.weekday - 1];
  }
}
