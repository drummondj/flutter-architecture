import 'package:architecture/core/domain/usecases/query_entities.dart';
import 'package:architecture/features/todos/domain/entites/todo.dart';
import 'package:injectable/injectable.dart';

@injectable
class QueryTodos extends QueryEntities<Todo> {
  QueryTodos({required super.eventBus});
}
