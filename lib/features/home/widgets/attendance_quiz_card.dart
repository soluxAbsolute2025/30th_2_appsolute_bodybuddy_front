import 'package:flutter/material.dart';

import '../api/attendance_api.dart';
import '../models/attendance_question_model.dart';
import '../models/attendance_answer_result_model.dart';

class AttendanceQuizCard extends StatefulWidget {
  const AttendanceQuizCard({super.key});

  @override
  State<AttendanceQuizCard> createState() => _AttendanceQuizCardState();
}

class _AttendanceQuizCardState extends State<AttendanceQuizCard> {
  late Future<AttendanceQuestion> _future;
  int? selectedOptionId;
  bool isSubmitting = false;
  bool isAnswered = false;

  @override
  void initState() {
    super.initState();
    _future = AttendanceApi().fetchQuestion();
  }

  Future<void> _submit(AttendanceQuestion quiz) async {
    if (isSubmitting || isAnswered) return;
    if (selectedOptionId == null) return;

    setState(() => isSubmitting = true);

    try {
      final AttendanceAnswerResult result = await AttendanceApi().submitAnswer(
        questionId: quiz.questionId,
        optionId: selectedOptionId!,
      );

      setState(() {
        isAnswered = true;
      });

      if (!mounted) return;

      // ✅ 여기 모달/오버레이 네 기존 UI로 바꿔 끼우면 됨
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(result.correct ? '정답이에요 🎉' : '틀렸어요 😢'),
          content: Text(
            result.correct
                ? '+${result.earnedPoint} XP 획득!'
                : '획득 XP: ${result.earnedPoint}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('제출 실패: $e')),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AttendanceQuestion>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _loadingCard();
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return _errorCard();
        }

        final quiz = snapshot.data!;

        return Container(
          padding: const EdgeInsets.all(16),
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
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFFFBBE),
                          Color(0xFFE8FFF9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: const Color(0xFF1AEDB1),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '+ ${quiz.rewardPoint} XP',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1AEDB1),
                        height: 1.2,
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
                  onTap: (isAnswered || isSubmitting)
                      ? null
                      : () => setState(() {
                            selectedOptionId = option.id;
                          }),
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE9FFF9) : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF21EAB0)
                            : const Color(0xFFD8D8D8),
                        width: 0.7,
                      ),
                    ),
                    child: Text(
                      option.text,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color:
                            isSelected ? const Color(0xFF18D9A2) : Colors.black,
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 36,
                child: ElevatedButton(
                  onPressed: (selectedOptionId == null || isSubmitting || isAnswered)
                      ? null
                      : () => _submit(quiz),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1AEDB1),
                    disabledBackgroundColor: const Color(0xFFBFEFE3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isSubmitting
                        ? '제출 중...'
                        : (isAnswered ? '제출 완료' : '제출하기'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _loadingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _errorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Expanded(child: Text('퀴즈를 불러오지 못했어요.')),
          TextButton(
            onPressed: () {
              setState(() {
                _future = AttendanceApi().fetchQuestion();
              });
            },
            child: const Text('재시도'),
          ),
        ],
      ),
    );
  }
}
