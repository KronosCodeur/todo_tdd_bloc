import 'package:dartz/dartz.dart';
import 'package:todo_tdd_bloc/core/error/exceptions.dart';
import 'package:todo_tdd_bloc/core/error/failures.dart';
import 'package:todo_tdd_bloc/features/todo/data/datasources/todo_local_datasource.dart';
import 'package:todo_tdd_bloc/features/todo/data/models/todo_model.dart';
import 'package:todo_tdd_bloc/features/todo/domain/entities/response_entity.dart';
import 'package:todo_tdd_bloc/features/todo/domain/entities/todo.dart';
import 'package:todo_tdd_bloc/features/todo/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    try {
      final todos = await localDataSource.getCachedTodos();
      return Right(todos);
    } on CacheException {

      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ResponseEntity<Todo>>> addTodo(String title) async {
    try {
      final currentTodos = await localDataSource.getCachedTodos();

      // Générer un nouvel ID (simple pour l'exemple)
      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      final newTodo = TodoModel(
        id: newId,
        title: title,
        isCompleted: false,
      );

      final updatedTodos = [...currentTodos, newTodo];
      await localDataSource.cacheTodos(updatedTodos);

      return Right(ResponseEntity(
        data: newTodo,
        success: true,
        message: 'Todo added successfully',
      ));
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Todo>> toggleTodo(String id) async {
    try {
      final currentTodos = await localDataSource.getCachedTodos();

      final todoIndex = currentTodos.indexWhere((todo) => todo.id == id);
      if (todoIndex == -1) {
        return Left(CacheFailure());
      }

      final todoToToggle = currentTodos[todoIndex];
      final toggledTodo = TodoModel(
        id: todoToToggle.id,
        title: todoToToggle.title,
        isCompleted: !todoToToggle.isCompleted,
      );

      final updatedTodos = [...currentTodos];
      updatedTodos[todoIndex] = toggledTodo;

      await localDataSource.cacheTodos(updatedTodos);

      return Right(toggledTodo);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTodo(String id) async {
    try {
      final currentTodos = await localDataSource.getCachedTodos();
      final updatedTodos = currentTodos.where((todo) => todo.id != id).toList();

      await localDataSource.cacheTodos(updatedTodos);

      return const Right(unit);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}