import 'package:dio/dio.dart';
import '../../../api/dio_client.dart';
import '../models/todo_model.dart';

class TodoApi {
  final Dio _dio = DioClient.dio;

  // GET /api/todos/today
  Future<List<Todo>> fetchTodayTodos() async {
    final res = await _dio.get('/api/todos/today');

    final list = res.data as List;
    return list.map((e) => Todo.fromJson(e as Map<String, dynamic>)).toList();
  }

  // PATCH /api/todos/{todoId}
  Future<void> updateTodoCompleted({
    required int todoId,
    required bool completed,
  }) async {
    await _dio.patch(
      '/api/todos/$todoId',
      data: {'completed': completed},
    );
  }
}
