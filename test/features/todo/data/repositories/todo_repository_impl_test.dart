import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_tdd_bloc/core/error/exceptions.dart';
import 'package:todo_tdd_bloc/core/error/failures.dart';
import 'package:todo_tdd_bloc/features/todo/data/datasources/todo_local_datasource.dart';
import 'package:todo_tdd_bloc/features/todo/data/models/todo_model.dart';
import 'package:todo_tdd_bloc/features/todo/data/repositories/todo_repository_impl.dart';

class MockTodoLocalDataSource extends Mock implements TodoLocalDataSource {}

void main() {
  late TodoRepositoryImpl repository;
  late MockTodoLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockTodoLocalDataSource();
    repository = TodoRepositoryImpl(
      localDataSource: mockLocalDataSource,
    );
  });

  group('getTodos', () {
    final tTodoModels = [
      TodoModel(id: '1', title: 'Test 1', isCompleted: false),
      TodoModel(id: '2', title: 'Test 2', isCompleted: true),
    ];

    test('should return cached data when the call to local data source is successful', () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedTodos())
          .thenAnswer((_) async => tTodoModels);

      // Act
      final result = await repository.getTodos();

      // Assert
      verify(() => mockLocalDataSource.getCachedTodos());
      expect(result, equals(Right(tTodoModels)));
    });

    test('should return CacheFailure when there is no cached data', () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedTodos())
          .thenThrow(CacheException());

      // Act
      final result = await repository.getTodos();

      // Assert
      verify(() => mockLocalDataSource.getCachedTodos());
      expect(result, equals(Left(CacheFailure())));
    });
  });

  group('addTodo', () {
    const tTitle = 'New Todo';
    final tExistingTodos = [
      TodoModel(id: '1', title: 'Test 1', isCompleted: false),
    ];

    test('should add todo and cache the updated list', () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedTodos())
          .thenAnswer((_) async => tExistingTodos);
      when(() => mockLocalDataSource.cacheTodos(any()))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.addTodo(tTitle);

      // Assert
      verify(() => mockLocalDataSource.getCachedTodos());
      verify(() => mockLocalDataSource.cacheTodos(any()));

      result.fold(
            (failure) => fail('Should return Right'),
            (response) {
          expect(response.data.title, tTitle);
          expect(response.data.isCompleted, false);
          expect(response.success, true);
        },
      );
    });

    test('should return CacheFailure when caching fails', () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedTodos())
          .thenAnswer((_) async => tExistingTodos);
      when(() => mockLocalDataSource.cacheTodos(any()))
          .thenThrow(CacheException());

      // Act
      final result = await repository.addTodo(tTitle);

      // Assert
      expect(result, equals(Left(CacheFailure())));
    });
  });
}