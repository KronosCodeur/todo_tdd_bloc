import 'package:flutter/material.dart';
import 'package:todo_tdd_bloc/features/todo/domain/entities/todo.dart';
import 'package:todo_tdd_bloc/features/todo/presentation/widgets/todo_item.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;

  const TodoList({
    super.key,
    required this.todos,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return TodoItem(todo: todos[index]);
      },
    );
  }
}