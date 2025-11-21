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

import '../../../../mocks/mocks_todo.dart';

void main() {
  late TodoBloc bloc;
  late MockGetTodos mockGetTodos;
  late MockAddTodo mockAddTodo;
  late MockToggleTodo mockToggleTodo;
  late MockDeleteTodo mockDeleteTodo;
  setUp(() {
    mockGetTodos = MockGetTodos();
    mockAddTodo = MockAddTodo();
    mockToggleTodo = MockToggleTodo();
    mockDeleteTodo = MockDeleteTodo();
    bloc = TodoBloc(
      getTodos: mockGetTodos,
      addTodo: mockAddTodo,
      toggleTodo: mockToggleTodo,
      deleteTodo: mockDeleteTodo,
    );
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
        when(() => mockGetTodos()).thenAnswer((_) async => Right(tTodos));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTodosEvent()),
      expect: () => [TodoLoading(), TodoLoaded(tTodos)],
      verify: (_) {
        verify(() => mockGetTodos());
      },
    );
  });

  group('AddTodoEvent', () {
    const tTitle = 'New Todo';
    final tNewTodo = Todo(id: '3', title: 'New Todo', isCompleted: false);
    final tExistingTodos = [Todo(id: '1', title: 'Test 1', isCompleted: false)];

    blocTest<TodoBloc, TodoState>(
      'should emit [TodoLoading, TodoLoaded] with new todo added',
      build: () {
        when(() => mockAddTodo(any())).thenAnswer(
          (_) async => Right(
            ResponseEntity<Todo>(
              data: tNewTodo,
              success: true,
              message: 'Todo added successfully',
            ),
          ),
        );
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
        when(
          () => mockAddTodo(any()),
        ).thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      seed: () => TodoLoaded(tExistingTodos),
      act: (bloc) => bloc.add(AddTodoEvent(tTitle)),
      expect: () => [TodoLoading(), TodoError('Server Failure')],
    );
  });
  group('ToggleTodoEvent', () {
    final tTodos = [
      Todo(id: '1', title: 'Test 1', isCompleted: false),
      Todo(id: '2', title: 'Test 2', isCompleted: true),
    ];
    final tToggledTodo = Todo(id: '1', title: 'Test 1', isCompleted: true);

    blocTest<TodoBloc, TodoState>(
      'should emit [TodoLoading, TodoLoaded] with toggled todo',
      build: () {
        when(
          () => mockToggleTodo(any()),
        ).thenAnswer((_) async => Right(tToggledTodo));
        return bloc;
      },
      seed: () => TodoLoaded(tTodos),
      act: (bloc) => bloc.add(const ToggleTodoEvent('1')),
      expect: () => [
        TodoLoading(),
        TodoLoaded([tToggledTodo, tTodos[1]]),
      ],
      verify: (_) {
        verify(() => mockToggleTodo('1'));
      },
    );

    blocTest<TodoBloc, TodoState>(
      'should emit [TodoLoading, TodoError] when toggling fails',
      build: () {
        when(
          () => mockToggleTodo(any()),
        ).thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      seed: () => TodoLoaded(tTodos),
      act: (bloc) => bloc.add(const ToggleTodoEvent('1')),
      expect: () => [TodoLoading(), TodoError('Cache Failure')],
    );
  });

  group('DeleteTodoEvent', () {
    final tTodos = [
      Todo(id: '1', title: 'Test 1', isCompleted: false),
      Todo(id: '2', title: 'Test 2', isCompleted: true),
    ];

    blocTest<TodoBloc, TodoState>(
      'should emit [TodoLoading, TodoLoaded] with todo removed',
      build: () {
        when(
          () => mockDeleteTodo(any()),
        ).thenAnswer((_) async => const Right(unit));
        return bloc;
      },
      seed: () => TodoLoaded(tTodos),
      act: (bloc) => bloc.add(const DeleteTodoEvent('1')),
      expect: () => [
        TodoLoading(),
        TodoLoaded([tTodos[1]]),
      ],
      verify: (_) {
        verify(() => mockDeleteTodo('1'));
      },
    );

    blocTest<TodoBloc, TodoState>(
      'should emit [TodoLoading, TodoError] when deleting fails',
      build: () {
        when(
          () => mockDeleteTodo(any()),
        ).thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      seed: () => TodoLoaded(tTodos),
      act: (bloc) => bloc.add(const DeleteTodoEvent('1')),
      expect: () => [TodoLoading(), TodoError('Cache Failure')],
    );
  });
}
