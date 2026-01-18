import 'package:architecture/core/domain/usecases/delete_entity.dart';
import 'package:architecture/features/todos/domain/entites/todo.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteTodo extends DeleteEntity<Todo> {
  DeleteTodo({required super.eventBus});
}
