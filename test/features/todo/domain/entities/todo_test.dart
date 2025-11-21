import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_tdd_bloc/features/todo/domain/entities/todo.dart';

void main(){
  group('Todo Entity', (){
    test('should be a subclass of Equatable', (){
      final todo = Todo(id: '1', title: 'Test Todo', isCompleted: false);
      expect(todo, isA<Equatable>());
    });

    test('two todos with same properties should be equal', (){
      final todo1 = Todo(id: '1', title: 'Test Todo', isCompleted: false);
      final todo2 = Todo(id: '1', title: 'Test Todo', isCompleted: false);
      expect(todo1, equals(todo2));
    });
  });
}