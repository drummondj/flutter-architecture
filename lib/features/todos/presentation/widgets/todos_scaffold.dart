import 'package:architecture/core/presentation/widgets/app_drawer.dart';
import 'package:architecture/core/presentation/widgets/loading_indicator.dart';
import 'package:architecture/features/todos/domain/entites/todo.dart';
import 'package:architecture/features/todos/presentation/widgets/new_todo_dialog.dart';
import 'package:architecture/features/todos/presentation/widgets/todos_list.dart';
import 'package:flutter/material.dart';

class TodosScaffold extends StatelessWidget {
  final List<Todo> todos;
  final List<Widget> actions;
  final bool isUpdating;
  const TodosScaffold({
    super.key,
    required this.todos,
    required this.actions,
    required this.isUpdating,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todos"), centerTitle: true, actions: actions),
      drawer: AppDrawer(),

      body: SafeArea(
        child: todos.isNotEmpty
            ? TodosList(todos: todos)
            : (isUpdating
                  ? Center(child: LoadingIndicator())
                  : Center(child: Text("No todos found"))),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showNewTodoForm(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
