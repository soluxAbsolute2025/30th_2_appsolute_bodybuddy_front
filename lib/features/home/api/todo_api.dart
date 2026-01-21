import 'package:dio/dio.dart';
import '../../../api/dio_client.dart';
import '../models/todo_model.dart';

class TodoApi {
  final Dio _dio = DioClient.dio;

  /// GET /api/todos
  /// - null 또는 빈 데이터면 [] 반환 (에러 UI X)
  Future<List<Todo>> fetchTodayTodos() async {
    final res = await _dio.get('/api/todos');

    if (res.data == null) return [];

    // 기대 형태: { "medicine": [...], "water": [...], ... }
    if (res.data is! Map<String, dynamic>) return [];

    final data = res.data as Map<String, dynamic>;
    final todos = <Todo>[];

    for (final entry in data.entries) {
      final categoryKey = entry.key;
      final value = entry.value;

      if (value == null) continue;
      if (value is! List) continue;

      for (final item in value) {
        if (item is! Map<String, dynamic>) continue;

        todos.add(
          Todo.fromApiJson(
            categoryKey: categoryKey,
            json: item,
          ),
        );
      }
    }

    todos.sort((a, b) => a.time.compareTo(b.time));

    return todos;
  }

  /// PATCH /api/todos/check/{todoId}
  Future<void> updateTodoCompleted({
    required int todoId,
    required bool completed,
  }) async {
    await _dio.patch(
      '/api/todos/check/$todoId',
      data: {'completed': completed},
    );
  }
}
