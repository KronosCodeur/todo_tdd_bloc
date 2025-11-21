import 'package:dartz/dartz.dart';
import 'package:todo_tdd_bloc/core/error/failures.dart';
import 'package:todo_tdd_bloc/features/todo/domain/entities/response_entity.dart';
import 'package:todo_tdd_bloc/features/todo/domain/entities/todo.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<Todo>>> getTodos();
  Future<Either<Failure, ResponseEntity<Todo>>> addTodo(String title);
  Future<Either<Failure, Todo>> toggleTodo(String id);
  Future<Either<Failure, Unit>> deleteTodo(String id);
}
