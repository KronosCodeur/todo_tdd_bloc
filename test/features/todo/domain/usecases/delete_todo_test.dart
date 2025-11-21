import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_tdd_bloc/features/todo/domain/repositories/todo_repository.dart';
import 'package:todo_tdd_bloc/features/todo/domain/usecases/delete_todo.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late DeleteTodo usecase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    usecase = DeleteTodo(mockRepository);
  });

  test('should delete todo through the repository', () async {
    // Arrange
    const tId = '1';

    when(() => mockRepository.deleteTodo(any()))
        .thenAnswer((_) async => const Right(unit));

    // Act
    final result = await usecase(tId);

    // Assert
    expect(result, const Right(unit));
    verify(() => mockRepository.deleteTodo(tId));
    verifyNoMoreInteractions(mockRepository);
  });
}