class AttendanceAnswerResult {
  final bool correct;
  final int earnedPoint;
  final String correctAnswer;

  const AttendanceAnswerResult({
    required this.correct,
    required this.earnedPoint,
    required this.correctAnswer,
  });

  factory AttendanceAnswerResult.fromJson(Map<String, dynamic> json) {
    return AttendanceAnswerResult(
      correct: json['correct'] as bool,
      earnedPoint: json['earnedPoint'] as int,
      correctAnswer: json['correctAnswer'] as String,
    );
  }
}
