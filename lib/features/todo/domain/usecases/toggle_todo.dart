import 'package:dartz/dartz.dart';
import 'package:todo_tdd_bloc/core/error/failures.dart';
import 'package:todo_tdd_bloc/features/todo/domain/entities/todo.dart';
import 'package:todo_tdd_bloc/features/todo/domain/repositories/todo_repository.dart';

class ToggleTodo {
  final TodoRepository repository;

  ToggleTodo(this.repository);

  Future<Either<Failure, Todo>> call(String id) async {
    return await repository.toggleTodo(id);
  }
}
