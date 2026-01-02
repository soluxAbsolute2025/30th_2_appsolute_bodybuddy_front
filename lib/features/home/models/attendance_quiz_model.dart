class AttendanceQuiz {
  final int questionId;
  final String question;
  final int rewardPoint;
  final List<QuizOption> options;

  AttendanceQuiz({
    required this.questionId,
    required this.question,
    required this.rewardPoint,
    required this.options,
  });
}

class QuizOption {
  final int id;
  final String text;

  QuizOption({
    required this.id,
    required this.text,
  });
}
