import 'package:flutter/material.dart';
import '../data/dummy_todos.dart';
import '../models/todo_model.dart';
import 'todo_item.dart';

class TodayTodoSection extends StatefulWidget {
  const TodayTodoSection({super.key});

  @override
  State<TodayTodoSection> createState() => _TodayTodoSectionState();
}

class _TodayTodoSectionState extends State<TodayTodoSection> {
  late List<Todo> todos;

  @override
  void initState() {
    super.initState();
    todos = _filteredAndSortedTodos();
  }

  List<Todo> _filteredAndSortedTodos() {
    final today = _todayKey();

    final todayTodos = dummyTodos
        .where((t) => t.repeatDays.contains(today))
        .toList();

    todayTodos.sort((a, b) => a.time.compareTo(b.time));

    return todayTodos;
  }

  void _toggleTodo(Todo todo) {
    setState(() {
      todos = todos.map((t) {
        if (t.todoId == todo.todoId) {
          return t.copyWith(completed: !t.completed);
        }
        return t;
      }).toList();
    });

    /// TODO: 완료 처리 API 호출
  }

  @override
  Widget build(BuildContext context) {
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

  String _todayKey() {
    const map = {
      DateTime.monday: 'MON',
      DateTime.tuesday: 'TUE',
      DateTime.wednesday: 'WED',
      DateTime.thursday: 'THU',
      DateTime.friday: 'FRI',
      DateTime.saturday: 'SAT',
      DateTime.sunday: 'SUN',
    };
    return map[DateTime.now().weekday]!;
  }
}
