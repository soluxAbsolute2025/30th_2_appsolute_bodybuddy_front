import 'package:flutter/material.dart';
import 'attendance_header.dart';
import 'attendance_quiz_card.dart';
import 'attendance_week_strip.dart';

class AttendanceSection extends StatelessWidget {
  const AttendanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      constraints: const BoxConstraints(
        minHeight: 300,
      ),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-1.2, -0.5),
          end: Alignment(1.0, 1.0),
          colors: [
            Color(0xFFFDFAD4),
            Color(0xFFB8FFED), 
          ],
          stops: [
            0.3,
            0.7,
          ],
        ),
      ),

      // 내부 콘텐츠 패딩
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            AttendanceHeader(),
            SizedBox(height: 16),
            AttendanceQuizCard(),
            SizedBox(height: 16),
            AttendanceWeekStrip(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
