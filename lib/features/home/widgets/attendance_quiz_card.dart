import 'package:flutter/material.dart';
import '../data/dummy_attendance_quiz.dart';

class AttendanceQuizCard extends StatefulWidget {
  const AttendanceQuizCard({super.key});

  @override
  State<AttendanceQuizCard> createState() => _AttendanceQuizCardState();
}

class _AttendanceQuizCardState extends State<AttendanceQuizCard> {
  int? selectedOptionId;

  @override
  Widget build(BuildContext context) {
    final quiz = dummyAttendanceQuiz;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Q.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1BE4AB),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  quiz.question,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1AEDB1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '+ ${quiz.rewardPoint} XP',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFFF43D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          ...quiz.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = selectedOptionId == option.id;
            final isLast = index == quiz.options.length - 1;

            return GestureDetector(
              onTap: () => setState(() {
                selectedOptionId = option.id;
              }),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: isLast ? 0 : 8,),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFE9FFF9)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF21EAB0)
                        : const Color(0xFFD8D8D8),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  option.text,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF18D9A2)
                        : Colors.black,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
