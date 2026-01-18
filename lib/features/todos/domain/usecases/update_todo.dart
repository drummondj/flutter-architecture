import 'package:architecture/core/domain/usecases/update_entity.dart';
import 'package:architecture/features/todos/domain/entites/todo.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateTodo extends UpdateEntity<Todo> {
  UpdateTodo({required super.eventBus});
}
