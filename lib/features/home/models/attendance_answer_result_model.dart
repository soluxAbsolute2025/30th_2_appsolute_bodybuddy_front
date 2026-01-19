class AttendanceAnswerResult {
  final bool correct;
  final int earnedPoint;

  const AttendanceAnswerResult({
    required this.correct,
    required this.earnedPoint,
  });

  factory AttendanceAnswerResult.fromJson(Map<String, dynamic> json) {
    return AttendanceAnswerResult(
      correct: json['correct'] as bool,
      earnedPoint: json['earnedPoint'] as int,
    );
  }
}
