import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodosEvent extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final String title;

  const AddTodoEvent(this.title);

  @override
  List<Object?> get props => [title];
}

class ToggleTodoEvent extends TodoEvent {
  final String id;

  const ToggleTodoEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteTodoEvent extends TodoEvent {
  final String id;

  const DeleteTodoEvent(this.id);

  @override
  List<Object?> get props => [id];
}
