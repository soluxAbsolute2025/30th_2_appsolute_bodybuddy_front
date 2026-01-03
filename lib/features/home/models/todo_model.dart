enum TodoCategory {
  MEDICINE,
  WATER,
  EXERCISE,
  MEAL,
}

class Todo {
  final int todoId;
  final TodoCategory category;
  final String title;
  final String time; // "HH:mm"
  final bool completed;
  final List<String> repeatDays;

  Todo({
    required this.todoId,
    required this.category,
    required this.title,
    required this.time,
    required this.completed,
    required this.repeatDays,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      todoId: json['todoId'],
      category: TodoCategory.values
          .firstWhere((e) => e.name == json['category']),
      title: json['title'],
      time: json['time'],
      completed: json['completed'],
      repeatDays: List<String>.from(json['repeatDays']),
    );
  }

  Todo copyWith({bool? completed}) {
    return Todo(
      todoId: todoId,
      category: category,
      title: title,
      time: time,
      completed: completed ?? this.completed,
      repeatDays: repeatDays,
    );
  }
}
