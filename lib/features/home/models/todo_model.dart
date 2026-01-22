enum TodoCategory { MEDICINE, WATER, EXERCISE, MEAL }

TodoCategory todoCategoryFromKey(String key) {
  switch (key) {
    case 'medicine':
      return TodoCategory.MEDICINE;
    case 'water':
      return TodoCategory.WATER;
    case 'exercise':
      return TodoCategory.EXERCISE;
    case 'meal':
      return TodoCategory.MEAL;
    default:
      throw Exception('Unknown category key: $key');
  }
}

class Todo {
  final int todoId; // notificationId
  final TodoCategory category;
  final String title;
  final String time; // "HH:mm:ss"
  final bool completed; // checked

  const Todo({
    required this.todoId,
    required this.category,
    required this.title,
    required this.time,
    required this.completed,
  });

  factory Todo.fromApiJson({
    required String categoryKey,
    required Map<String, dynamic> json,
  }) {
    return Todo(
      todoId: json['notificationId'] as int,
      category: todoCategoryFromKey(categoryKey),
      title: (json['title'] ?? '') as String,
      time: (json['time'] ?? '') as String,
      completed: (json['checked'] ?? false) as bool,
    );
  }

  Todo copyWith({bool? completed}) {
    return Todo(
      todoId: todoId,
      category: category,
      title: title,
      time: time,
      completed: completed ?? this.completed,
    );
  }
}
