import '../models/todo_model.dart';

final dummyTodos = [
  Todo(
    todoId: 1,
    category: TodoCategory.MEDICINE,
    title: '비타민 먹기',
    time: '17:00',
    completed: true,
  ),
  Todo(
    todoId: 2,
    category: TodoCategory.WATER,
    title: '물 마시기',
    time: '14:00',
    completed: false,
  ),
  Todo(
    todoId: 3,
    category: TodoCategory.EXERCISE,
    title: '런닝하기',
    time: '07:00',
    completed: false,
  ),
  Todo(
    todoId: 4,
    category: TodoCategory.MEAL,
    title: '단백질 쉐이크',
    time: '19:00',
    completed: false,
  ),
];
