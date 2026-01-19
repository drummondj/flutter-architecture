import 'package:architecture/core/presentation/cubits/entity_state.dart';
import 'package:architecture/core/presentation/widgets/loading_indicator.dart';
import 'package:architecture/features/tags/presentation/widgets/tag_selector.dart';
import 'package:architecture/features/todos/domain/entites/todo.dart';
import 'package:architecture/features/todos/presentation/cubits/todos_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class TodoForm extends StatefulWidget {
  final Todo? initialTodo;

  const TodoForm({super.key, this.initialTodo});

  @override
  State<StatefulWidget> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  bool get _isNew => widget.initialTodo == null;
  bool _updating = false;
  final _formKey = GlobalKey<FormBuilderState>();

  void _onClose() {
    Navigator.of(context).pop();
  }

  void _setUpdating(bool value) {
    setState(() {
      _updating = value;
    });
  }

  void _onDelete() {
    context.read<TodosCubit>().delete(widget.initialTodo!);
  }

  void _onSave() async {
    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    }

    final value = _formKey.currentState!.value;
    final String title = (value["title"] ?? '').trim();
    final List<String> tagIds = (value["tagIds"] ?? []);

    if (_isNew) {
      context.read<TodosCubit>().create(Todo(title: title, tagIds: tagIds));
    } else {
      context.read<TodosCubit>().update(
        widget.initialTodo!,
        widget.initialTodo!.copyWith(title: title, tagIds: tagIds),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TodosCubit, EntityState<Todo>>(
        listener: (context, state) {
          switch (state) {
            case EntityInitialState<Todo>() ||
                EntityLoadingState<Todo>() ||
                EntityErrorState<Todo>():
              break;
            case EntityLoadedState<Todo>(status: final status):
              switch (status) {
                case EntityStateStatus.loaded || EntityStateStatus.error:
                  _setUpdating(false);
                case EntityStateStatus.updating ||
                    EntityStateStatus.loading ||
                    EntityStateStatus.initial:
                  _setUpdating(true);
                case EntityStateStatus.updated:
                  _setUpdating(false);
                  _onClose();
              }
          }
        },
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              // Toolbar
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 8,
                children: [
                  IconButton(
                    key: const Key('TodoForm-CloseButton'),
                    onPressed: !_updating ? () => _onClose() : null,
                    icon: const Icon(Icons.close),
                  ),
                  const Spacer(),
                  if (_updating)
                    const LoadingIndicator(size: LoadingIndicatorSize.small),
                  if (!_isNew)
                    IconButton(
                      key: const Key('TodoForm-DeleteButton'),
                      icon: Icon(
                        Icons.delete_outlined,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: !_updating ? _onDelete : null,
                    ),
                  FilledButton.icon(
                    key: const Key('TodoForm-SaveButton'),
                    onPressed: !_updating ? _onSave : null,
                    label: Text(_isNew ? 'Add' : 'Update'),
                    icon: Icon(_isNew ? Icons.add : Icons.upload),
                  ),
                ],
              ),
              FormBuilderTextField(
                name: "title",
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Title",
                ),
                initialValue: widget.initialTodo?.title,
              ),
              TagSelector(initialTagIds: widget.initialTodo?.tagIds ?? []),
            ],
          ),
        ),
      ),
    );
  }
}
