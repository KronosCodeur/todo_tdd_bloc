import 'package:todo_tdd_bloc/features/todo/domain/entities/todo.dart';

class TodoModel  extends Todo{
  const TodoModel({required String id, required String title, required bool isCompleted}):
        super(id: id, title: title, isCompleted: isCompleted);

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
      };
}