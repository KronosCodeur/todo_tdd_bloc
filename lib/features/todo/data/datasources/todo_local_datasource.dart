

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_tdd_bloc/core/error/exceptions.dart';
import 'package:todo_tdd_bloc/features/todo/data/models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getCachedTodos();
  Future<void> cacheTodos(List<TodoModel> todos);
}

const String cachedTodos = 'CACHED_TODOS';

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final SharedPreferences sharedPreferences;

  TodoLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<TodoModel>> getCachedTodos() {
    final jsonString = sharedPreferences.getString(cachedTodos);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(
        jsonList.map((json) => TodoModel.fromJson(json)).toList(),
      );
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheTodos(List<TodoModel> todos) {
    final jsonString = json.encode(
      todos.map((todo) => todo.toJson()).toList(),
    );
    return sharedPreferences.setString(cachedTodos, jsonString);
  }
}