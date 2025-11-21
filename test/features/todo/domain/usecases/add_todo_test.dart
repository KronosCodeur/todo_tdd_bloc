import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_tdd_bloc/features/todo/domain/entities/response_entity.dart';
import 'package:todo_tdd_bloc/features/todo/domain/entities/todo.dart';
import 'package:todo_tdd_bloc/features/todo/domain/usecases/add_todo.dart';
import '../../../../mocks/todo/mock_todo_repository.dart';
void main() {
  late AddTodo usecase;
  late MockTodoRepository mockTodoRepository;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    usecase = AddTodo(mockTodoRepository);
  });

  test('should add a todo through the repository', () async {
    const tTitle = 'New Todo';
    final tTodo = Todo(id: '1', title: tTitle, isCompleted: false);
    when(() => mockTodoRepository.addTodo(tTitle))
        .thenAnswer((_) async => Right(ResponseEntity<Todo>(data: tTodo, success: true, message: 'Todo added successfully')));
    final result = await usecase(tTitle);
    expect(result, Right(ResponseEntity<Todo>(data: tTodo, success: true, message: 'Todo added successfully')));
    verify(() => mockTodoRepository.addTodo(tTitle));
    verifyNoMoreInteractions(mockTodoRepository);
  });

}