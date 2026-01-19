# Flutter Clean Architecture Project

This project demonstrates clean architecture principles for Flutter apps with event-driven state management.

## Architecture Overview

### Three-Layer Structure per Feature
Each feature in `lib/features/` follows a strict three-layer architecture:

- **domain/** - Business logic layer
  - `entities/` - Data models extending `EntityWithIdAndTimestamps` (use `@CopyWith()` decorator)
  - `repositories/` - Abstract repository interfaces marked with `@factoryMethod`
  - `usecases/` - Business operations extending base use cases (CreateEntity, UpdateEntity, DeleteEntity, QueryEntities)

- **data/** - Data access layer
  - `repositories/` - Concrete implementations (e.g., FakeTodosRepo extending FakeEntityRepo)
  - Use `@Singleton(as: EntityRepo<T>)` for dependency injection

- **presentation/** - UI layer
  - `cubits/` - State management extending EntityCubit
  - `pages/` - Top-level page widgets using BlocConsumer
  - `widgets/` - Reusable UI components (e.g., TodosScaffold)

### Event-Driven Architecture
This project uses `jozz_events` for decoupled communication:

- **CRUD Events**: CreateEntityEvent, UpdateEntityEvent, DeleteEntityEvent, QueryRequestEvent/ResponseEvent
- **Flow**: UseCases emit events → Repositories listen and perform operations → Emit result events → Cubits update state
- **Example**: CreateTodo.call() emits CreateEntityEvent → FakeTodosRepo.create() processes → Emits UpdateEntityAfterPersistenceEvent → TodosCubit updates state

### Query System
Use QueryBuilder for named, reusable queries:
```dart
QueryBuilder(name: "default")
  .limit(50)
  .where('completed', equals: false)
  .orderBy('createdAt', descending: true)
```
- Named queries stored in EntityCubit's `searchResults` Map
- Supports pagination via `startAfterDocument()`
- Conditions: equals, greaterThan, lessThan, contains, isNull, arrayContainsAny, whereIn

### Dependency Injection
Using `injectable` with `get_it`:
- Run `dart run build_runner watch -d` after adding new `@injectable` or `@lazySingleton` classes
- Register feature-specific dependencies in their respective domain/usecases
- Access via `getIt<TodosCubit>()` in main.dart

### Result Type Pattern
All repository operations return `Result<T>`:
```dart
Future<Result<Todo>> create(Todo todo);
```
- Use pattern matching: `switch (result) { case Ok(:final value) => ..., case Error(:final error) => ... }`
- `Error.sanitizedErrorMessage` provides user-friendly error messages (UserException) or generic fallback

## Development Workflows

### Code Generation
Always run in watch mode during development:
```bash
dart run build_runner watch -d
```
Generates files for: @CopyWith, @injectable, and json_serializable

### Adding a New Feature
1. Create `lib/features/<feature_name>/{domain,data,presentation}` directories
2. Define entity in `domain/entities/` extending EntityWithIdAndTimestamps
3. Create abstract repo in `domain/repositories/` with `@factoryMethod`
4. Implement concrete repo in `data/repositories/` with `@Singleton(as: EntityRepo<T>)`
5. Create use cases extending base classes (CreateEntity<T>, etc.) with `@injectable`
6. Build cubit extending EntityCubit<T> with `@lazySingleton`
7. Register in MultiBlocProvider in main.dart
8. Run build_runner to generate DI code

### State Management Pattern
EntityCubit manages optimistic updates:
- Immediate UI updates when CRUD operations called
- Rollback on persistence errors via EntityPersistenceError events
- Query results stored by name in `searchResults` Map
- Use `EntityLoadedState.status` to show loading indicators during background operations

## Key Conventions

- Use `const` constructors for entities and widgets where possible
- All entities must extend EntityWithIdAndTimestamps for timestamp tracking
- Cubits are lazySingleton, repositories are Singleton
- Page widgets use BlocConsumer to handle both state changes and side effects
- Loading states: EntityInitialState (no data), EntityLoadingState (query in progress)
- Always use named queries for tracking multiple query results simultaneously

## Cross-Cubit Communication

### Data Access Pattern
Cubits expose helper methods for other features to query their state:

```dart
// In TagsCubit - expose data
List<Tag> getTagsById(List<String> tagIds) {
  return getAllTags().where((e) => tagIds.contains(e.uid)).toList();
}

// In TodosList widget - access via context.read()
context.read<TagsCubit>().getTagsById(todo.tagIds)
```

**Key Points:**
- Use synchronous getter methods for reading data across cubits
- Always preload dependent data in initState() before querying
- Data Relationships: Todos store `tagIds` (List<String>), Tags store `todoCount` (int)

### Side-Effect Pattern (Event-Driven)
For reactive updates when one cubit's changes should trigger updates in another, subscribe to CRUD events:

```dart
@lazySingleton
class TagsCubit extends EntityCubit<Tag> {
  TagsCubit({
    required super.eventBus,
    // ... other dependencies
  }) : super() {
    // Subscribe to other feature's CRUD events
    eventBus.autoListen<CreateEntityEvent<Todo>>(this, handleCreateTodoEvent);
    eventBus.autoListen<DeleteEntityEvent<Todo>>(this, handleDeleteTodoEvent);
    eventBus.autoListen<UpdateEntityEvent<Todo>>(this, handleUpdateTodoEvent);
  }

  void handleCreateTodoEvent(CreateEntityEvent<Todo> event) {
    // Increment Tag.todoCount for selected tags
    for (final tag in getTagsById(event.entity.tagIds)) {
      update(tag, tag.copyWith(todoCount: tag.todoCount + 1));
    }
  }

  void handleUpdateTodoEvent(UpdateEntityEvent<Todo> event) {
    // Calculate differential updates
    List<String> removedTagIds = event.originalEntity.tagIds
        .where((e) => !event.newEntity.tagIds.contains(e))
        .toList();
    List<String> addedTagIds = event.newEntity.tagIds
        .where((e) => !event.originalEntity.tagIds.contains(e))
        .toList();

    for (final tag in getTagsById(removedTagIds)) {
      update(tag, tag.copyWith(todoCount: tag.todoCount - 1));
    }
    for (final tag in getTagsById(addedTagIds)) {
      update(tag, tag.copyWith(todoCount: tag.todoCount + 1));
    }
  }
}
```

**Implementation Steps:**
1. Subscribe to relevant CRUD events in the cubit's constructor using `eventBus.autoListen<EventType<Entity>>(this, handler)`
2. Create handler methods that perform side-effects (update counts, sync related data, etc.)
3. Use helper methods like `getTagsById()` to resolve related entities
4. Call `update()` to persist changes through the normal event flow
5. For update events, calculate diffs to avoid unnecessary operations (only update what changed)

## Common Pitfalls

- Forgetting to run build_runner after adding @injectable annotations
- Not using named queries leads to search results being overwritten
- Mixing UserException (shown to users) with InternalException (logged only)
- Calling createEntity directly instead of through the cubit's create() method
- Accessing cross-cubit data before preloading it (always preload in initState)
