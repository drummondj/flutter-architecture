import 'package:architecture/core/domain/usecases/create_entity.dart';
import 'package:architecture/features/todos/domain/entites/todo.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateTodo extends CreateEntity<Todo> {
  CreateTodo({required super.eventBus});
}
