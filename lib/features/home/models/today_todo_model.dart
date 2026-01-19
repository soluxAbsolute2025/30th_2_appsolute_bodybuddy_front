class TodayTodo {
  final int todoId;
  final String title;
  final String time; // "HH:mm"
  final bool completed;

  const TodayTodo({
    required this.todoId,
    required this.title,
    required this.time,
    required this.completed,
  });

  factory TodayTodo.fromJson(Map<String, dynamic> json) {
    return TodayTodo(
      todoId: json['todoId'] as int,
      title: json['title'] as String,
      time: json['time'] as String,
      completed: json['completed'] as bool,
    );
  }

  TodayTodo copyWith({bool? completed}) {
    return TodayTodo(
      todoId: todoId,
      title: title,
      time: time,
      completed: completed ?? this.completed,
    );
  }
}
