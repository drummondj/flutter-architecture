import 'package:architecture/features/tags/presentation/cubits/tags_cubit.dart';
import 'package:architecture/features/todos/domain/entites/todo.dart';
import 'package:architecture/features/todos/presentation/cubits/todos_cubit.dart';
import 'package:architecture/features/todos/presentation/widgets/edit_todo_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodosList extends StatelessWidget {
  const TodosList({super.key, required this.todos});

  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return ListTile(
          leading: Checkbox(
            value: todo.completed,
            onChanged: (value) => context.read<TodosCubit>().update(
              todo.copyWith(completed: value ?? false),
            ),
          ),
          title: Text("${todo.uid ?? "Unknown"} ${todo.title}"),
          subtitle: todo.tagIds.isNotEmpty
              ? Text(
                  context
                      .read<TagsCubit>()
                      .getTagsById(todo.tagIds)
                      .map((e) => e.name)
                      .join(" "),
                )
              : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => showEditTodoForm(context, todo),
                icon: Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: () => context.read<TodosCubit>().delete(todo),
                icon: Icon(Icons.delete_outline),
              ),
            ],
          ),
        );
      },
    );
  }
}
