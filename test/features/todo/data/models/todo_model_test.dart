import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_tdd_bloc/features/todo/data/models/todo_model.dart';
import 'package:todo_tdd_bloc/features/todo/domain/entities/todo.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tTodoModel = TodoModel(
    id: '1',
    title: 'Test Todo',
    isCompleted: false,
  );

  test('should be a subclass of Todo entity', () {
    expect(tTodoModel, isA<Todo>());
  });

  group('fromJson', () {
    test('should return a valid model from JSON', () {
      final Map<String, dynamic> jsonMap = json.decode(
        fixture('todo.json'),
      );
      final result = TodoModel.fromJson(jsonMap);
      expect(result, tTodoModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () {
      final result = tTodoModel.toJson();

      final expectedMap = {
        'id': '1',
        'title': 'Test Todo',
        'isCompleted': false,
      };
      expect(result, expectedMap);
    });
  });
}