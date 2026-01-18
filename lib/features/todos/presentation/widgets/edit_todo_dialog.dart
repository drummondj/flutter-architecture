import 'package:architecture/features/todos/domain/entites/todo.dart';
import 'package:architecture/features/todos/presentation/widgets/todo_form.dart';
import 'package:flutter/material.dart';

void showEditTodoForm(BuildContext context, Todo todo) {
  showModalBottomSheet(
    context: context,
    builder: (context) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: TodoForm(initialTodo: todo),
    ),
  );
}
