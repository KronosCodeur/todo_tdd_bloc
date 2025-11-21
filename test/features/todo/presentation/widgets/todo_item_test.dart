import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_tdd_bloc/features/todo/domain/entities/todo.dart';
import 'package:todo_tdd_bloc/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_tdd_bloc/features/todo/presentation/bloc/todo_event.dart';
import 'package:todo_tdd_bloc/features/todo/presentation/bloc/todo_state.dart';
import 'package:todo_tdd_bloc/features/todo/presentation/widgets/todo_item.dart';

import '../../../../mocks/mocks_todo.dart';

void main() {
  late MockTodoBloc mockTodoBloc;

  setUp(() {
    mockTodoBloc = MockTodoBloc();
    when(() => mockTodoBloc.state).thenReturn(TodoInitial());
    when(() => mockTodoBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<TodoBloc>.value(
        value: mockTodoBloc,
        child: Scaffold(body: body),
      ),
    );
  }

  group('Todo Item Widget', () {
    final testTodo = Todo(id: '1', title: 'Test Todo', isCompleted: false);
    final completedTodo = Todo(
      id: '2',
      title: 'Completed Todo',
      isCompleted: true,
    );

    testWidgets('should display todo title', (tester) async {
      await tester.pumpWidget(makeTestableWidget(TodoItem(todo: testTodo)));
      expect(find.text('Test Todo'), findsOneWidget);
    });

    testWidgets('should display unchecked checkbox for incomplete todo', (
      tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(TodoItem(todo: testTodo)));
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, false);
    });

    testWidgets('should display checked checkbox for completed todo', (
      tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(TodoItem(todo: completedTodo)),
      );
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, true);
    });

    testWidgets('should addToggleTodoEvent when checkbox is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(TodoItem(todo: testTodo)));
      await tester.tap(find.byType(Checkbox));
      verify(() => mockTodoBloc.add(ToggleTodoEvent(testTodo.id))).called(1);
    });

    testWidgets('should show delete dialog when delete icon is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(TodoItem(todo: testTodo)));
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();
      expect(find.text('Delete Todo'), findsOneWidget);
      expect(
        find.text('Are you sure you want to delete "Test Todo"?'),
        findsOneWidget,
      );
    });
  });
}
