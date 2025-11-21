import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_tdd_bloc/features/todo/data/datasources/todo_local_datasource.dart';
import 'package:todo_tdd_bloc/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:todo_tdd_bloc/features/todo/domain/repositories/todo_repository.dart';
import 'package:todo_tdd_bloc/features/todo/domain/usecases/add_todo.dart';
import 'package:todo_tdd_bloc/features/todo/domain/usecases/delete_todo.dart';
import 'package:todo_tdd_bloc/features/todo/domain/usecases/get_todos.dart';
import 'package:todo_tdd_bloc/features/todo/domain/usecases/toggle_todo.dart';
import 'package:todo_tdd_bloc/features/todo/presentation/bloc/todo_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Todo
  // Bloc
  sl.registerFactory(
    () => TodoBloc(
      getTodos: sl(),
      addTodo: sl(),
      toggleTodo: sl(),
      deleteTodo: sl(),
    ),
  );
  // Use cases
  sl.registerLazySingleton(() => GetTodos(sl()));
  sl.registerLazySingleton(() => AddTodo(sl()));
  sl.registerLazySingleton(() => ToggleTodo(sl()));
  sl.registerLazySingleton(() => DeleteTodo(sl()));

  // Repository
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
