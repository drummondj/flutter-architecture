import 'package:architecture/core/domain/query_builder/query_builder.dart';
import 'package:architecture/core/presentation/cubits/entity_state.dart';
import 'package:architecture/core/presentation/extensions/entity_state_extensions.dart';
import 'package:architecture/core/presentation/widgets/error_page.dart';
import 'package:architecture/core/presentation/widgets/loading_indicator.dart';
import 'package:architecture/core/presentation/widgets/loading_page.dart';
import 'package:architecture/features/tags/presentation/cubits/tags_cubit.dart';
import 'package:architecture/features/todos/domain/entites/todo.dart';
import 'package:architecture/features/todos/presentation/cubits/todos_cubit.dart';
import 'package:architecture/features/todos/presentation/widgets/todos_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  int limit = 50;
  bool completed = false;

  @override
  void initState() {
    super.initState();

    // pre-load tags
    context.read<TagsCubit>().loadAllTags();

    // pre-load todos
    _runQuery();
  }

  void _runQuery() {
    context.read<TodosCubit>().query(
      QueryBuilder(
        name: "default",
      ).limit(limit).where('completed', equals: completed),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodosCubit, EntityState<Todo>>(
      builder: (BuildContext context, state) {
        switch (state) {
          case EntityErrorState<Todo>():
            return ErrorPage(
              message: "There was a problem loading todos.",
              onRetry: _runQuery,
            );
          case EntityInitialState<Todo>() || EntityLoadingState<Todo>():
            return LoadingPage();
          case EntityLoadedState<Todo>(
            searchResults: final searchResult,
            status: final status,
          ):
            return TodosScaffold(
              todos: searchResult["default"]?.entities ?? [],
              isUpdating: status == EntityStateStatus.updating,
              actions: [
                if (status == EntityStateStatus.updating) ...[
                  LoadingIndicator(size: LoadingIndicatorSize.small),
                  SizedBox(width: 8),
                ],
                Switch(
                  value: completed,
                  onChanged: (value) {
                    setState(() {
                      completed = value;
                    });
                    _runQuery();
                  },
                ),
              ],
            );
        }
      },
      listener: (BuildContext context, state) {
        debugPrint("State: $state");
        context.showEntityMessage(state);
      },
    );
  }
}
