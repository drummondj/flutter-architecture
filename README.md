# architecture

The purpose of this project is to define best practices for future flutter projects, based on my learning from the whatnext project development.

## TODO

* ✅ Named searches - QueryRequestEvents should accept a name String and Cubits should store results in a HashMap
* ✅ ReactiveScaffold - for tablets etc
* ✅ Check createAt and updatedAt updates are working
* Implement FirebaseEntityRepo
* Model validation
* Tests

## Packages

Install the following packages for new projects:

```bash
flutter pub add equatable
flutter pub add copy_with_extension
flutter pub add cloud_firestore
flutter pub add json_annotation
flutter pub add bloc_flutter
flutter pub add get_it
flutter pub add injectable
flutter pub add synchronized
flutter pub add jozz_events
flutter pub add dev:build_runner
flutter pub add dev:copy_with_extension_gen
flutter pub add dev:injectable_generator
```

## Architecure

### Directory structure

Inside the `lib` directory there are two sub-directories:

* core - for generic code independent of any specific feature.
* features - contains a sub-directory for each feature.

Each feature directory contains the following (using the todos example):

```
domain/
   entites/
      todo.dart - Todo model definition
   repositories/
      todos_repo.dart - Abstract interface definition of a TodoRepo
   usercase/ - UseCase definition for business logic for CRUD operations
      create_todo.dart
      delete_todo.dart
      query_todo.dart
      update_todo.dart
      ... more use cases as required ...
data/
   repositories/ - contains all implementations of a TodoRepo (i.e. FirebaseTodoRepo, FakeTodoRepo etc)
      fake_todos_repo.dart - concreate implementation of a TodoRepo (used for UI mock ups)
   services/ - contains any other services that aren't releated to data storage, such as 3rd party API calls etc
      ...
presentation/
   cubits/
      todos_cubit.dart - state management for the TodosPage
      todos_states.dart - state definitions
   pages/
      todos_page.dart - top-level TodosPage widget (handles cubit state changes and renders appropriate Scaffolds)
   widgets/
      todos_scaffold.dart - Main widget on TodosPage that is used when all Todos are loaded
      ... more widgets used by the TodosScaffold ...
```

### Domain

#### Entities

Example entity definition:

```dart
import 'package:architecture/core/entities/entity_with_id_and_timestamps.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'todo.g.dart';

@CopyWith()
class Todo extends EntityWithIdAndTimestamps {
  final String title;
  final bool completed;

  const Todo({
    super.uid,
    super.createdAt,
    super.updatedAt,
    required this.title,
    this.completed = false,
  });

  @override
  List<Object?> get props => [...super.props, title, completed];
}
```

Each enitity can extend:

* `EntityWithIdAndTimestamps` - to inherit `uid`, `createdAt` and `updatedAt` fields
* Or `Equatable` - for a fully customized model

The `@CopyWith()` decorator should be used to enable easy copying of entities without mutating the original data.

#### Repositories

Each feature can have one or more abstract repository classes:

```dart
class TodosQueryRequest extends Equatable {
  final bool? completed;
  final String? titleContains;

  const TodosQueryRequest({this.completed, this.titleContains});

  @override
  List<Object?> get props => [completed, titleContains];
}

class TodosQueryResponse {
  final List<Todo> todos;
  final TodosQueryRequest request;

  TodosQueryResponse({required this.todos, required this.request});
}

@factoryMethod
abstract class TodosRepo {
  Future<Result<Todo>> create(Todo todo);
  Future<Result<TodosQueryResponse>> query(TodosQueryRequest request);
  Future<Result<Todo>> update(Todo todo);
  Future<Result<Todo>> delete(Todo todo);
}
```

Each repository can define it's own request/response classes for any number of operations.

#### Use cases

Use cases define how operations are performed in each feature.
For the simplest of cases, these are just wrappers around the repository.
