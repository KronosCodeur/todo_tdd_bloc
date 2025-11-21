import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_tdd_bloc/features/todo/domain/entities/todo.dart';
import 'package:todo_tdd_bloc/features/todo/domain/usecases/toggle_todo.dart';

import '../../../../mocks/mocks_todo.dart';

void main() {
  late ToggleTodo usecase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    usecase = ToggleTodo(mockRepository);
  });

  test('should toggle todo through the repository', () async {
    // Arrange
    const tId = '1';
    final tTodo = Todo(id: '1', title: 'Test', isCompleted: true);

    when(
      () => mockRepository.toggleTodo(any()),
    ).thenAnswer((_) async => Right(tTodo));

    // Act
    final result = await usecase(tId);

    // Assert
    expect(result, Right(tTodo));
    verify(() => mockRepository.toggleTodo(tId));
    verifyNoMoreInteractions(mockRepository);
  });
}
