import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_tdd_bloc/features/todo/domain/entities/todo.dart';
import 'package:todo_tdd_bloc/features/todo/domain/repositories/todo_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_tdd_bloc/features/todo/domain/usecases/get_todos.dart';

import '../../../../mocks/todo/mock_todo_repository.dart';


void main() {
  late GetTodos usecase;
  late MockTodoRepository mockTodoRepository;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    usecase = GetTodos(mockTodoRepository);
  });

  test('should get todos from the repository', ()async{
    final tTodos = [
      Todo(id: '1', title: 'Test Todo 1', isCompleted: false),
      Todo(id: '2', title: 'Test Todo 2', isCompleted: true),
    ];
    when(() => mockTodoRepository.getTodos())
        .thenAnswer((_) async => Right(tTodos));

    final result = await usecase();
    expect(result, Right(tTodos));
    verify(() => mockTodoRepository.getTodos());
    verifyNoMoreInteractions(mockTodoRepository);
  });
}