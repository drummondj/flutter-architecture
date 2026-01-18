import 'package:architecture/features/todos/presentation/widgets/todo_form.dart';
import 'package:flutter/material.dart';

void showNewTodoForm(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) =>
        Padding(padding: const EdgeInsets.all(8.0), child: TodoForm()),
  );
}
