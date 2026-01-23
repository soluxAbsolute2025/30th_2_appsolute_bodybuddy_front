import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/attendance_api.dart';
import '../../../common/kst_time.dart';
import '../models/attendance_question_model.dart';
import '../models/attendance_answer_result_model.dart';

// ✅ 예시: 프로젝트에 있는 Common.userId를 사용한다고 가정
import '../../../common/common.dart';

class AttendanceQuizCard extends StatefulWidget {
  final VoidCallback? onSolved;

  const AttendanceQuizCard({super.key, this.onSolved});

  @override
  State<AttendanceQuizCard> createState() => _AttendanceQuizCardState();
}

class _AttendanceQuizCardState extends State<AttendanceQuizCard> {
  late Future<AttendanceQuestion?> _future;

  int? selectedOptionId;
  bool isSubmitting = false;
  bool isAnswered = false;
  bool? lastCorrect;

  String? correctAnswer;
  int? earnedPoint;

  // ✅ base key (고정 문자열은 base로만 유지)
  static const _baseAnsweredDate = 'attendance_quiz_answered_date';
  static const _baseSelectedOption = 'attendance_quiz_selected_option';
  static const _baseQuizCache = 'attendance_quiz_cache_json';
  static const _baseLastCorrect = 'attendance_quiz_last_correct';
  static const _baseCorrectAnswer = 'attendance_quiz_correct_answer';
  static const _baseEarnedPoint = 'attendance_quiz_earned_point';

  // ✅ user prefix (userId 기반)
  String _userPrefix() {
    final uid = Common.userId; // int? 또는 String? 일 수 있음
    // 로그인 전이면 임시 prefix (원하면 throw로 강제해도 됨)
    if (uid == null) return 'user_unknown';
    return 'user_$uid';
  }

  // ✅ 최종 key 생성기
  String _k(String base) => '${_userPrefix()}_$base';

  // ✅ 실제 사용할 key getter들
  String get _answeredDateKey => _k(_baseAnsweredDate);
  String get _selectedOptionKey => _k(_baseSelectedOption);
  String get _quizCacheKey => _k(_baseQuizCache);
  String get _lastCorrectKey => _k(_baseLastCorrect);
  String get _correctAnswerKey => _k(_baseCorrectAnswer);
  String get _earnedPointKey => _k(_baseEarnedPoint);

  @override
  void initState() {
    super.initState();
    _future = _init();
  }

  String _todayKey() {
    final now = nowKST();
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  AttendanceQuestion? _decodeQuiz(String? raw) {
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return AttendanceQuestion.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveQuizCache(
    SharedPreferences prefs,
    AttendanceQuestion quiz,
  ) async {
    await prefs.setString(_quizCacheKey, jsonEncode(quiz.toJson()));
  }

  Future<void> _clearIfNewDay(SharedPreferences prefs) async {
    final savedDate = prefs.getString(_answeredDateKey);
    final today = _todayKey();

    if (savedDate != null && savedDate != today) {
      await prefs.remove(_answeredDateKey);
      await prefs.remove(_selectedOptionKey);
      await prefs.remove(_quizCacheKey);
      await prefs.remove(_lastCorrectKey);
      await prefs.remove(_correctAnswerKey);
      await prefs.remove(_earnedPointKey);
    }
  }

  Future<AttendanceQuestion?> _init() async {
    final prefs = await SharedPreferences.getInstance();
    await _clearIfNewDay(prefs);

    final today = _todayKey();
    final savedDate = prefs.getString(_answeredDateKey);
    final savedOption = prefs.getInt(_selectedOptionKey);
    final cachedQuiz = _decodeQuiz(prefs.getString(_quizCacheKey));

    if (savedDate == today) {
      final savedCorrect = prefs.getBool(_lastCorrectKey);
      final savedCorrectAnswer = prefs.getString(_correctAnswerKey);
      final savedEarnedPoint = prefs.getInt(_earnedPointKey);

      setState(() {
        isAnswered = true;
        selectedOptionId = savedOption;
        lastCorrect = savedCorrect;
        correctAnswer = savedCorrectAnswer;
        earnedPoint = savedEarnedPoint;
      });

      if (cachedQuiz != null) return cachedQuiz;

      final q = await AttendanceApi().fetchQuestion();
      if (q != null) {
        await _saveQuizCache(prefs, q);
        return q;
      }
      return null;
    }

    setState(() {
      isAnswered = false;
      selectedOptionId = null;
      lastCorrect = null;
      correctAnswer = null;
      earnedPoint = null;
    });

    final quiz = await AttendanceApi().fetchQuestion();
    if (quiz != null) {
      await _saveQuizCache(prefs, quiz);
    }
    return quiz;
  }

  void _showComeTomorrowModal() {
    if (!mounted) return;

    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('이미 참여했어요'),
        content: const Text('오늘은 이미 퀴즈를 완료했어요. 내일 다시 참여할 수 있어요!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitOnTap({
    required AttendanceQuestion quiz,
    required int optionId,
  }) async {
    if (isSubmitting) return;

    if (isAnswered) {
      _showComeTomorrowModal();
      return;
    }

    setState(() {
      isSubmitting = true;
      selectedOptionId = optionId;
    });

    try {
      final AttendanceAnswerResult result = await AttendanceApi().submitAnswer(
        questionId: quiz.questionId,
        optionId: optionId,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_answeredDateKey, _todayKey());
      await prefs.setInt(_selectedOptionKey, optionId);
      await prefs.setBool(_lastCorrectKey, result.correct);
      await prefs.setString(_correctAnswerKey, result.correctAnswer);
      await prefs.setInt(_earnedPointKey, result.earnedPoint);
      await _saveQuizCache(prefs, quiz);

      if (!mounted) return;

      setState(() {
        isAnswered = true;
        lastCorrect = result.correct;
        correctAnswer = result.correctAnswer;
        earnedPoint = result.earnedPoint;
      });

      widget.onSolved?.call();

      showDialog(
        context: context,
        useRootNavigator: true,
        builder: (dialogCtx) => AlertDialog(
          title: Text(result.correct ? '정답' : '틀렸어요'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('정답: ${result.correctAnswer}'),
              const SizedBox(height: 8),
              Text('획득 XP: ${result.earnedPoint}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isAnswered = false;
        correctAnswer = null;
        earnedPoint = null;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('제출 실패: $e')));
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AttendanceQuestion?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _loadingCard();
        }
        if (snapshot.hasError) {
          return _errorCard();
        }

        final quiz = snapshot.data;
        if (quiz == null) return _fallbackDoneCard();

        final xpText = (isAnswered && earnedPoint != null)
            ? '+ $earnedPoint XP'
            : '+ ${quiz.rewardPoint} XP';

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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFFBBE), Color(0xFFE8FFF9)],
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
                      xpText,
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
                final option = entry.value;
                final isLast = entry.key == quiz.options.length - 1;

                final isSelected = selectedOptionId == option.id;
                final isCorrectSelected =
                    isAnswered && isSelected && lastCorrect == true;
                final isWrongSelected =
                    isAnswered && isSelected && lastCorrect == false;

                Color bgColor = Colors.white;
                Color borderColor = const Color(0xFFD8D8D8);
                Color textColor = Colors.black;

                if (isCorrectSelected) {
                  bgColor = const Color(0xFFE9FFF9);
                  borderColor = const Color(0xFF21EAB0);
                  textColor = const Color(0xFF18D9A2);
                }

                if (isWrongSelected) {
                  bgColor = Colors.white;
                  borderColor = const Color(0xFFFF3B09);
                  textColor = const Color(0xFFFF3B09);
                }

                return GestureDetector(
                  onTap: () => _submitOnTap(quiz: quiz, optionId: option.id),
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: borderColor, width: 0.7),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option.text,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _fallbackDoneCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        '오늘은 이미 참여했어요. 내일 다시 할 수 있어요!',
        style: TextStyle(fontSize: 12, color: Color(0xFF7D7C7C)),
      ),
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
            onPressed: () => setState(() => _future = _init()),
            child: const Text('재시도'),
          ),
        ],
      ),
    );
  }
}
