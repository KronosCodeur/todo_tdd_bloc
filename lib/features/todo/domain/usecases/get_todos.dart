import 'package:dartz/dartz.dart';
import 'package:todo_tdd_bloc/core/error/failures.dart';
import 'package:todo_tdd_bloc/features/todo/domain/entities/todo.dart';
import 'package:todo_tdd_bloc/features/todo/domain/repositories/todo_repository.dart';

class GetTodos {
  final TodoRepository repository;

  GetTodos(this.repository);

  Future<Either<Failure, List<Todo>>> call() async {
    return await repository.getTodos();
  }
}
