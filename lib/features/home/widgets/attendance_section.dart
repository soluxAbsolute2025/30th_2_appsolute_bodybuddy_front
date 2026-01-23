import 'package:flutter/material.dart';
import 'attendance_header.dart';
import 'attendance_quiz_card.dart';
import 'attendance_week_strip.dart';

class AttendanceSection extends StatefulWidget {
  const AttendanceSection({super.key});

  @override
  State<AttendanceSection> createState() => _AttendanceSectionState();
}

class _AttendanceSectionState extends State<AttendanceSection> {
  bool _forceStampToday = false;

  void _onQuizSolved() {
    setState(() {
      _forceStampToday = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 300),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-1.2, -0.5),
          end: Alignment(1.0, 1.0),
          colors: [
            Color(0xFFFDFAD4),
            Color(0xFFB8FFED),
          ],
          stops: [0.3, 0.7],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AttendanceHeader(),
            const SizedBox(height: 16),

            AttendanceQuizCard(onSolved: _onQuizSolved),

            const SizedBox(height: 16),

            AttendanceWeekStrip(
              forceStampToday: _forceStampToday,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
