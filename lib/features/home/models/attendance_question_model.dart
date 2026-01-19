class AttendanceOption {
  final int id;
  final String text;

  const AttendanceOption({required this.id, required this.text});

  factory AttendanceOption.fromJson(Map<String, dynamic> json) {
    return AttendanceOption(
      id: json['id'] as int,
      text: json['text'] as String,
    );
  }
}

class AttendanceQuestion {
  final int questionId;
  final String question;
  final int rewardPoint;
  final List<AttendanceOption> options;

  const AttendanceQuestion({
    required this.questionId,
    required this.question,
    required this.rewardPoint,
    required this.options,
  });

  factory AttendanceQuestion.fromJson(Map<String, dynamic> json) {
    return AttendanceQuestion(
      questionId: json['questionId'] as int,
      question: json['question'] as String,
      rewardPoint: json['rewardPoint'] as int,
      options: (json['options'] as List)
          .map((e) => AttendanceOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
