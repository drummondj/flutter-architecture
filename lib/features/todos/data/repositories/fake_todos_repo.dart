import 'package:architecture/core/data/repositories/entity_repo.dart';
import 'package:architecture/core/data/repositories/fake_entity_repo.dart';
import 'package:architecture/features/todos/domain/entites/todo.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: EntityRepo<Todo>)
class FakeTodosRepo extends FakeEntityRepo<Todo> {
  FakeTodosRepo({required super.eventBus}) : super() {
    entities.addAll([
      Todo(
        uid: '1',
        title: 'Buy groceries',
        completed: false,
        createdAt: DateTime.now(),
        tagIds: ["1"],
      ),
      Todo(
        uid: '2',
        title: 'Finish project report',
        completed: true,
        createdAt: DateTime.now(),
        tagIds: ["2"],
      ),
      Todo(
        uid: '3',
        title: 'Call dentist',
        completed: false,
        createdAt: DateTime.now(),
        tagIds: ["1", "2"],
      ),
      Todo(
        uid: '4',
        title: 'Water the plants',
        completed: false,
        createdAt: DateTime.now(),
        tagIds: ["2", "1"],
      ),
      Todo(
        uid: '5',
        title: 'Read a book',
        completed: true,
        createdAt: DateTime.now(),
      ),
      Todo(
        uid: '6',
        title: 'Schedule team meeting',
        completed: false,
        createdAt: DateTime.now(),
      ),
      Todo(
        uid: '7',
        title: 'Update resume',
        completed: false,
        createdAt: DateTime.now(),
      ),
      Todo(
        uid: '8',
        title: 'Clean the garage',
        completed: true,
        createdAt: DateTime.now(),
      ),
      Todo(
        uid: '9',
        title: 'Plan weekend trip',
        completed: false,
        createdAt: DateTime.now(),
      ),
      Todo(
        uid: '10',
        title: 'Fix bike tire',
        completed: false,
        createdAt: DateTime.now(),
      ),
    ]);
  }
}
