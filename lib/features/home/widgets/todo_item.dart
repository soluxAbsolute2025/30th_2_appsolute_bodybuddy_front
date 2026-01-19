import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = todo.completed;

    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isDone ? const Color(0xFFEAFFFA) : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isDone
                ? const Color(0xFF1AEDB1)
                : const Color(0xFFD9D9D9),
          ),
        ),
        child: Row(
          children: [
            _CheckCircle(isChecked: isDone),
            const SizedBox(width: 10),
            _CategoryIcon(category: todo.category),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                todo.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Row(
              children: [
                Image.asset(
                  'assets/home/todo_clock.png',
                  width: 12,
                  height: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  todo.time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7D7C7C),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckCircle extends StatelessWidget {
  final bool isChecked;

  const _CheckCircle({required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isChecked ? const Color(0xFF1AEDB1) : Colors.white,
        border: Border.all(
          color: isChecked
              ? const Color(0xFF1AEDB1)
              : const Color(0xFFDBDBDB),
        ),
      ),
      child: isChecked
          ? const Icon(Icons.check, size: 8, color: Colors.white)
          : const Icon(Icons.check, size: 8, color: Color(0xFFDBDBDB)),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final TodoCategory category;

  const _CategoryIcon({required this.category});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _iconPath,
      width: 12,
      height: 12,
      fit: BoxFit.contain,
    );
  }

  String get _iconPath {
    switch (category) {
      case TodoCategory.MEDICINE:
        return 'assets/home/todo_medicine.png';
      case TodoCategory.WATER:
        return 'assets/home/todo_water.png';
      case TodoCategory.EXERCISE:
        return 'assets/home/todo_exercise.png';
      case TodoCategory.MEAL:
        return 'assets/home/todo_meal.png';
    }
  }
}

