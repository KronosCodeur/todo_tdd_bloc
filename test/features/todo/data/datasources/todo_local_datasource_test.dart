import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_tdd_bloc/core/error/exceptions.dart';
import 'package:todo_tdd_bloc/features/todo/data/datasources/todo_local_datasource.dart';
import 'package:todo_tdd_bloc/features/todo/data/models/todo_model.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late TodoLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = TodoLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getCachedTodos', () {
    final tTodoModels = [
      TodoModel(id: '1', title: 'Test 1', isCompleted: false),
      TodoModel(id: '2', title: 'Test 2', isCompleted: true),
    ];

    test('should return todos from SharedPreferences when there is data', () async {
      final jsonString = fixture('todos_cached.json');
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(jsonString);

      final result = await dataSource.getCachedTodos();

      verify(() => mockSharedPreferences.getString('CACHED_TODOS'));
      expect(result, equals(tTodoModels));
    });

    test('should throw CacheException when there is no cached data', () async {
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(null);

      final call = dataSource.getCachedTodos;

      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheTodos', () {
    final tTodoModels = [
      TodoModel(id: '1', title: 'Test 1', isCompleted: false),
    ];

    test('should call SharedPreferences to cache the data', () async {
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);

      await dataSource.cacheTodos(tTodoModels);

      final expectedJsonString = json.encode(
        tTodoModels.map((todo) => todo.toJson()).toList(),
      );
      verify(() => mockSharedPreferences.setString(
        'CACHED_TODOS',
        expectedJsonString,
      ));
    });
  });
}