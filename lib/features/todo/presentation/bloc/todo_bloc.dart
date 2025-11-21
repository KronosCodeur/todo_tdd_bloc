import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_tdd_bloc/core/error/failures.dart';
import 'package:todo_tdd_bloc/features/todo/domain/entities/todo.dart';
import 'package:todo_tdd_bloc/features/todo/domain/usecases/get_todos.dart';
import 'package:todo_tdd_bloc/features/todo/domain/usecases/add_todo.dart';
import 'package:todo_tdd_bloc/features/todo/presentation/bloc/todo_event.dart';
import 'package:todo_tdd_bloc/features/todo/presentation/bloc/todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;
  final AddTodo addTodo;

  TodoBloc({
    required this.getTodos,
    required this.addTodo,
  }) : super(TodoInitial()) {
    on<LoadTodosEvent>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
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
    // Garder les todos actuels
    final currentState = state;
    final currentTodos = currentState is TodoLoaded ? currentState.todos : <Todo>[];

    emit(TodoLoading());

    final failureOrTodo = await addTodo(event.title);

    failureOrTodo.fold(
          (failure) => emit(TodoError(_mapFailureToMessage(failure))),
          (response) => emit(TodoLoaded([...currentTodos, response.data])),
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