import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_tdd_bloc/core/error/failures.dart';
import 'package:todo_tdd_bloc/features/todo/domain/entities/todo.dart';
import 'package:todo_tdd_bloc/features/todo/domain/usecases/delete_todo.dart';
import 'package:todo_tdd_bloc/features/todo/domain/usecases/get_todos.dart';
import 'package:todo_tdd_bloc/features/todo/domain/usecases/add_todo.dart';
import 'package:todo_tdd_bloc/features/todo/domain/usecases/toggle_todo.dart';
import 'package:todo_tdd_bloc/features/todo/presentation/bloc/todo_event.dart';
import 'package:todo_tdd_bloc/features/todo/presentation/bloc/todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;
  final AddTodo addTodo;
  final ToggleTodo toggleTodo;
  final DeleteTodo deleteTodo;

  TodoBloc({
    required this.getTodos,
    required this.addTodo,
    required this.toggleTodo,
    required this.deleteTodo,
  }) : super(TodoInitial()) {
    on<LoadTodosEvent>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<ToggleTodoEvent>(_onToggleTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
  }

  Future<void> _onLoadTodos(
      LoadTodosEvent event,
      Emitter<TodoState> emit,
      ) async {
    emit(TodoLoading());

    final failureOrTodos = await getTodos();

    failureOrTodos.fold(
          (failure) => emit(TodoError(_mapFailureToMessage(failure))),
          (todos) => emit(TodoLoaded(todos)),
    );
  }

  Future<void> _onAddTodo(
      AddTodoEvent event,
      Emitter<TodoState> emit,
      ) async {
    final currentState = state;
    final currentTodos = currentState is TodoLoaded ? currentState.todos : <Todo>[];

    emit(TodoLoading());

    final failureOrTodo = await addTodo(event.title);

    failureOrTodo.fold(
          (failure) => emit(TodoError(_mapFailureToMessage(failure))),
          (response) => emit(TodoLoaded([...currentTodos, response.data])),
    );
  }

  Future<void> _onToggleTodo(
      ToggleTodoEvent event,
      Emitter<TodoState> emit,
      ) async {
    final currentState = state;
    if (currentState is! TodoLoaded) return;

    final currentTodos = currentState.todos;
    emit(TodoLoading());

    final failureOrTodo = await toggleTodo(event.id);

    failureOrTodo.fold(
          (failure) => emit(TodoError(_mapFailureToMessage(failure))),
          (toggledTodo) {
        final updatedTodos = currentTodos.map((todo) {
          return todo.id == toggledTodo.id ? toggledTodo : todo;
        }).toList();
        emit(TodoLoaded(updatedTodos));
      },
    );
  }

  Future<void> _onDeleteTodo(
      DeleteTodoEvent event,
      Emitter<TodoState> emit,
      ) async {
    final currentState = state;
    if (currentState is! TodoLoaded) return;

    final currentTodos = currentState.todos;
    emit(TodoLoading());

    final failureOrUnit = await deleteTodo(event.id);

    failureOrUnit.fold(
          (failure) => emit(TodoError(_mapFailureToMessage(failure))),
          (_) {
        final updatedTodos = currentTodos.where((todo) => todo.id != event.id).toList();
        emit(TodoLoaded(updatedTodos));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server Failure';
    } else if (failure is CacheFailure) {
      return 'Cache Failure';
    } else {
      return 'Unexpected Error';
    }
  }
}