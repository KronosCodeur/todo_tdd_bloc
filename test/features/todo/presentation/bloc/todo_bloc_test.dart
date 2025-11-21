import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_tdd_bloc/core/error/failures.dart';
import 'package:todo_tdd_bloc/features/todo/domain/entities/response_entity.dart';
import 'package:todo_tdd_bloc/features/todo/domain/entities/todo.dart';
import 'package:todo_tdd_bloc/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_tdd_bloc/features/todo/presentation/bloc/todo_event.dart';
import 'package:todo_tdd_bloc/features/todo/presentation/bloc/todo_state.dart';
import 'package:bloc_test/bloc_test.dart';
import '../../../../mocks/todo/mock_add_todo.dart';
import '../../../../mocks/todo/mock_get_todos.dart';

void main (){
  late TodoBloc bloc;
  late MockGetTodos mockGetTodos;
  late MockAddTodo mockAddTodo;

  setUp((){
    mockGetTodos = MockGetTodos();
    mockAddTodo = MockAddTodo();
    bloc = TodoBloc(getTodos: mockGetTodos, addTodo: mockAddTodo);
  });
    test('initial state should be TodoInitial', () {
      expect(bloc.state, equals(TodoInitial()));
    });
    group('LoadTodosEvent', () {
      final tTodos = [
        Todo(id: '1', title: 'Test 1', isCompleted: false),
        Todo(id: '2', title: 'Test 2', isCompleted: true),
      ];

      blocTest<TodoBloc, TodoState>(
        'should emit [TodoLoading, TodoLoaded] when data is gotten successfully',
        build: () {
          when(() => mockGetTodos())
              .thenAnswer((_) async => Right(tTodos));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadTodosEvent()),
        expect: () => [
          TodoLoading(),
          TodoLoaded(tTodos),
        ],
        verify: (_) {
          verify(() => mockGetTodos());
        },
      );
  });

  group('AddTodoEvent', () {
    const tTitle = 'New Todo';
    final tNewTodo = Todo(id: '3', title: 'New Todo', isCompleted: false);
    final tExistingTodos = [
       Todo(id: '1', title: 'Test 1', isCompleted: false),
    ];

    blocTest<TodoBloc, TodoState>(
      'should emit [TodoLoading, TodoLoaded] with new todo added',
      build: () {
        when(() => mockAddTodo(any()))
            .thenAnswer((_) async =>  Right(ResponseEntity<Todo>(data: tNewTodo, success: true, message: 'Todo added successfully')));
        return bloc;
      },
      seed: () => TodoLoaded(tExistingTodos),
      act: (bloc) => bloc.add(AddTodoEvent(tTitle)),
      expect: () => [
        TodoLoading(),
        TodoLoaded([...tExistingTodos, tNewTodo]),
      ],
      verify: (_) {
        verify(() => mockAddTodo(tTitle));
      },
    );

    blocTest<TodoBloc, TodoState>(
      'should emit [TodoLoading, TodoError] when adding todo fails',
      build: () {
        when(() => mockAddTodo(any()))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      seed: () => TodoLoaded(tExistingTodos),
      act: (bloc) => bloc.add(AddTodoEvent(tTitle)),
      expect: () => [
        TodoLoading(),
        TodoError('Server Failure'),
      ],
    );
  });
}