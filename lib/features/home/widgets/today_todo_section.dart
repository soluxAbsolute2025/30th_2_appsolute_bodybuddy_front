import 'package:flutter/material.dart';
import '../api/todo_api.dart';
import '../models/todo_model.dart';
import 'todo_item.dart';

class TodayTodoSection extends StatefulWidget {
  const TodayTodoSection({super.key});

  @override
  State<TodayTodoSection> createState() => _TodayTodoSectionState();
}

class _TodayTodoSectionState extends State<TodayTodoSection> {
  final TodoApi _api = TodoApi();

  List<Todo> todos = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final result = await _api.fetchTodayTodos();
      if (!mounted) return;

      setState(() {
        todos = result; // 빈 리스트면 "오늘의 할 일이 없어요."
        isLoading = false;
        hasError = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        hasError = true; // 500/네트워크 등 “진짜 에러”
      });
    }
  }

  Future<void> _toggleTodo(Todo todo) async {
    final next = !todo.completed;

    // optimistic update
    setState(() {
      todos = todos.map((t) {
        if (t.todoId == todo.todoId) return t.copyWith(completed: next);
        return t;
      }).toList();
    });

    try {
      await _api.updateTodoCompleted(todoId: todo.todoId, completed: next);
    } catch (e) {
      if (!mounted) return;

      // rollback
      setState(() {
        todos = todos.map((t) {
          if (t.todoId == todo.todoId) return t.copyWith(completed: !next);
          return t;
        }).toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('완료 처리 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (hasError) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Expanded(child: Text('오늘의 할 일을 불러오지 못했어요.')),
            TextButton(onPressed: _loadTodos, child: const Text('재시도')),
          ],
        ),
      );
    }

    // ✅ null/빈 데이터면 여기로 옴
    if (todos.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD8D8D8)),
        ),
        child: const Text(
          '오늘의 할 일이 없어요.',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14,
            color: Color(0xFF7D7C7C),
          ),
        ),
      );
    }

    // ✅ 정상 리스트
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD8D8D8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '오늘의 할 일',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          ...todos.asMap().entries.map((entry) {
            final index = entry.key;
            final todo = entry.value;
            final isLast = index == todos.length - 1;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
              child: TodoItem(
                todo: todo,
                onToggle: () => _toggleTodo(todo),
              ),
            );
          }),
        ],
      ),
    );
  }
}
