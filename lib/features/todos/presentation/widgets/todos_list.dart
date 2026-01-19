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
    return ListView.separated(
      itemCount: todos.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        final todo = todos[index];
        return ListTile(
          leading: Checkbox(
            value: todo.completed,
            onChanged: (value) => context.read<TodosCubit>().update(
              todo.copyWith(completed: value ?? false),
            ),
          ),
          title: Text(todo.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              if (todo.tagIds.isNotEmpty)
                Text(
                  context
                      .read<TagsCubit>()
                      .getTagsById(todo.tagIds)
                      .map((e) => e.name)
                      .join(" "),
                ),
              if (todo.createdAt != null)
                Text(
                  "Created at: ${todo.createdAt!.toString().split('.')[0]}",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              if (todo.updatedAt != null)
                Text(
                  "Updated at: ${todo.updatedAt!.toString().split('.')[0]}",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => showEditTodoForm(context, todo),
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: () => context.read<TodosCubit>().delete(todo),
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        );
      },
    );
  }
}
