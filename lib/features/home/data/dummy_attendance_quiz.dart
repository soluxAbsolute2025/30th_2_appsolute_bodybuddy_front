import '../models/attendance_quiz_model.dart';

final dummyAttendanceQuiz = AttendanceQuiz(
  questionId: 1,
  question: '하루 권장 수분 섭취량은 얼마일까요?',
  rewardPoint: 50,
  options: [
    QuizOption(id: 1, text: '1L'),
    QuizOption(id: 2, text: '1.5 - 2L'),
    QuizOption(id: 3, text: '3L'),
  ],
);
