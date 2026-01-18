import 'package:architecture/core/presentation/cubits/entity_cubit.dart';
import 'package:architecture/features/todos/domain/entites/todo.dart';
import 'package:architecture/features/todos/domain/usecases/create_todo.dart';
import 'package:architecture/features/todos/domain/usecases/delete_todo.dart';
import 'package:architecture/features/todos/domain/usecases/query_todos.dart';
import 'package:architecture/features/todos/domain/usecases/update_todo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TodosCubit extends EntityCubit<Todo> {
  TodosCubit({
    required super.eventBus,
    required CreateTodo super.createEntity,
    required UpdateTodo super.updateEntity,
    required DeleteTodo super.deleteEntity,
    required QueryTodos super.queryEntities,
  });
}
