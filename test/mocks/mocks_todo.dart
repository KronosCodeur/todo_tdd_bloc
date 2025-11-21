import 'package:mocktail/mocktail.dart';
import 'package:todo_tdd_bloc/features/todo/domain/repositories/todo_repository.dart';
import 'package:todo_tdd_bloc/features/todo/domain/usecases/add_todo.dart';
import 'package:todo_tdd_bloc/features/todo/domain/usecases/delete_todo.dart';
import 'package:todo_tdd_bloc/features/todo/domain/usecases/get_todos.dart';
import 'package:todo_tdd_bloc/features/todo/domain/usecases/toggle_todo.dart';
import 'package:todo_tdd_bloc/features/todo/presentation/bloc/todo_bloc.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

class MockGetTodos extends Mock implements GetTodos {}

class MockAddTodo extends Mock implements AddTodo {}

class MockToggleTodo extends Mock implements ToggleTodo {}

class MockDeleteTodo extends Mock implements DeleteTodo {}

class MockTodoBloc extends Mock implements TodoBloc {}
