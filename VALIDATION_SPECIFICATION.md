# Validation Specification

This document outlines validation techniques that fit the event-driven clean architecture used in this project.

## Overview

Validation should occur at multiple layers, with each layer handling different concerns:
- **Entity Layer**: Simple field validation (required, length, format)
- **UseCase Layer**: Business logic validation (rules, constraints)
- **Repository Layer**: Data integrity validation (uniqueness, foreign keys)

## Validation Helper Package

To avoid writing repetitive validation logic by hand, use the `validators` package combined with a custom `Validators` helper class.

### Installation

```bash
flutter pub add validators
```

### Custom Validators Helper

Create a reusable validators utility class:

```dart
// lib/core/validation/validators.dart
import 'package:validators/validators.dart' as v;

class Validators {
  // String validators
  static String? required(String? value, {String? fieldName}) {
    if (value == null || v.isEmpty(value.trim())) {
      return '${fieldName ?? "This field"} is required';
    }
    return null;
  }

  static String? maxLength(String? value, int max, {String? fieldName}) {
    if (value != null && !v.isLength(value, 0, max)) {
      return '${fieldName ?? "This field"} cannot exceed $max characters';
    }
    return null;
  }

  static String? minLength(String? value, int min, {String? fieldName}) {
    if (value != null && !v.isLength(value, min)) {
      return '${fieldName ?? "This field"} must be at least $min characters';
    }
    return null;
  }

  static String? lengthBetween(String? value, int min, int max, {String? fieldName}) {
    if (value != null && !v.isLength(value, min, max)) {
      return '${fieldName ?? "This field"} must be between $min and $max characters';
    }
    return null;
  }

  // Numeric validators
  static String? greaterThan(num? value, num min, {String? fieldName}) {
    if (value != null && value <= min) {
      return '${fieldName ?? "This field"} must be greater than $min';
    }
    return null;
  }

  static String? lessThan(num? value, num max, {String? fieldName}) {
    if (value != null && value >= max) {
      return '${fieldName ?? "This field"} must be less than $max';
    }
    return null;
  }

  static String? range(num? value, num min, num max, {String? fieldName}) {
    if (value != null && (value < min || value > max)) {
      return '${fieldName ?? "This field"} must be between $min and $max';
    }
    return null;
  }

  // Collection validators
  static String? maxItems<T>(List<T>? items, int max, {String? fieldName}) {
    if (items != null && items.length > max) {
      return '${fieldName ?? "This field"} cannot have more than $max items';
    }
    return null;
  }

  static String? minItems<T>(List<T>? items, int min, {String? fieldName}) {
    if (items != null && items.length < min) {
      return '${fieldName ?? "This field"} must have at least $min items';
    }
    return null;
  }

  // Format validators (from validators package)
  static String? email(String? value) {
    if (value == null || v.isEmpty(value)) return null;
    if (!v.isEmail(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  static String? url(String? value) {
    if (value == null || v.isEmpty(value)) return null;
    if (!v.isURL(value)) {
      return 'Invalid URL';
    }
    return null;
  }

  static String? numeric(String? value, {String? fieldName}) {
    if (value == null || v.isEmpty(value)) return null;
    if (!v.isNumeric(value)) {
      return '${fieldName ?? "This field"} must be a number';
    }
    return null;
  }

  // Combinator
  static String? combine(List<String? Function()> validators) {
    for (final validator in validators) {
      final error = validator();
      if (error != null) return error;
    }
    return null;
  }

  // Custom pattern
  static String? pattern(String? value, String pattern, {String? message}) {
    if (value == null || v.isEmpty(value)) return null;
    if (!v.matches(value, pattern)) {
      return message ?? 'Invalid format';
    }
    return null;
  }
}
```

### Usage Examples

**Simple Entity Validation:**
```dart
@CopyWith()
@JsonSerializable()
class Todo extends EntityWithIdAndTimestamps {
  final String title;
  final List<String> tagIds;

  // ... existing code ...

  String? validate() {
    return Validators.combine([
      () => Validators.required(title, fieldName: 'Title'),
      () => Validators.lengthBetween(title, 1, 200, fieldName: 'Title'),
      () => Validators.maxItems(tagIds, 10, fieldName: 'Tags'),
    ]);
  }
}
```

**Complex Entity Validation:**
```dart
@CopyWith()
@JsonSerializable()
class User extends EntityWithIdAndTimestamps {
  final String name;
  final String email;
  final int age;
  final String? website;

  // ... existing code ...

  String? validate() {
    return Validators.combine([
      () => Validators.required(name, fieldName: 'Name'),
      () => Validators.lengthBetween(name, 2, 100, fieldName: 'Name'),
      () => Validators.required(email, fieldName: 'Email'),
      () => Validators.email(email),
      () => Validators.range(age, 0, 150, fieldName: 'Age'),
      () => website != null ? Validators.url(website) : null,
    ]);
  }
}
```

### Available Validators

From the custom `Validators` class:
- **String**: `required()`, `minLength()`, `maxLength()`, `lengthBetween()`
- **Numeric**: `greaterThan()`, `lessThan()`, `range()`
- **Collections**: `maxItems()`, `minItems()`
- **Format**: `email()`, `url()`, `numeric()`, `pattern()`
- **Composition**: `combine()` - chains multiple validators

From the `validators` package (use directly):
- `isEmpty()`, `isNotEmpty()`
- `isAlpha()`, `isAlphanumeric()`
- `isNumeric()`, `isInt()`, `isFloat()`
- `isEmail()`, `isURL()`, `isFQDN()`
- `isIP()`, `isJSON()`, `isUUID()`
- `isCreditCard()`, `isISBN()`, `isISSN()`
- `matches(str, pattern)` - regex matching
- And many more...

### Benefits

- ✅ No repetitive validation code
- ✅ Consistent error messages
- ✅ Works seamlessly with `Result<T>` pattern
- ✅ Type-safe and testable
- ✅ Easy to extend with custom validators
- ✅ Reusable across all entities

## 1. UseCase-Level Validation (Recommended Primary Approach)

Validation should happen in the UseCase layer before emitting events. This keeps business rules in the domain layer where they belong.

### Implementation Pattern

```dart
@injectable
class CreateTodo extends CreateEntity<Todo> {
  CreateTodo({required super.eventBus});

  @override
  Future<Result<Todo>> call(Todo entity) async {
    // Validate using entity's validators
    final validationResult = entity.validate();
    if (!validationResult.isValid) {
      return Result.error(
        UserException(message: validationResult.firstError!)
      );
    }

    return super.call(entity);
  }
}
```

### Advantages
- Validation errors caught before events are emitted
- Returns `Result.error` - fits existing pattern
- Cubit receives error immediately through the Result type
- No optimistic update for invalid data
- Business logic stays in domain layer

## 2. Entity Method Validation

Entities provide their validation rules by overriding the `validators` getter. The base `EntityWithIdAndTimestamps` class executes these validators and returns a `ValidationResult`.

### Implementation Pattern

```dart
@CopyWith()
@JsonSerializable()
class Todo extends EntityWithIdAndTimestamps {
  final String title;
  final bool completed;
  final List<String> tagIds;

  // ... existing code ...

  @override
  List<String? Function()> get validators => [
    () => Validators.required(title, fieldName: 'Title'),
    () => Validators.lengthBetween(title, 1, 200, fieldName: 'Title'),
    () => Validators.maxItems(tagIds, 10, fieldName: 'Tags'),
  ];
}
```

### Base Class Implementation

The `EntityWithIdAndTimestamps` base class handles validation execution:

```dart
abstract class EntityWithIdAndTimestamps<T> extends Equatable {
  // ... fields ...

  /// Concrete implementations override this to provide their validation rules.
  List<String? Function()> get validators => [];

  /// Executes all validators and returns a ValidationResult.
  ValidationResult validate() {
    final errors = <String>[];

    for (final validator in validators) {
      final error = validator();
      if (error != null) {
        errors.add(error);
      }
    }

    return ValidationResult(
      status: errors.isEmpty ? ValidationStatus.pass : ValidationStatus.fail,
      errors: errors,
    );
  }
}
```

### ValidationResult

```dart
enum ValidationStatus { pass, fail }

class ValidationResult {
  final ValidationStatus status;
  final List<String> errors;

  ValidationResult({required this.status, required this.errors});

  bool get isValid => status == ValidationStatus.pass;
  String? get firstError => errors.isEmpty ? null : errors.first;
}
```

### Usage in UseCases

```dart
@injectable
class CreateTodo extends CreateEntity<Todo> {
  CreateTodo({required super.eventBus});

  @override
  Future<Result<Todo>> call(Todo entity) async {
    final validationResult = entity.validate();
    if (!validationResult.isValid) {
      return Result.error(
        UserException(message: validationResult.firstError!)
      );
    }
    return super.call(entity);
  }
}
```

### Advantages
- Validation logic lives with the entity it validates
- Declarative - just provide a list of validators
- Base class handles execution logic
- Reusable across create/update operations
- Easy to test independently
- Returns detailed `ValidationResult` with all errors
- Self-documenting entity constraints

## 3. Validator Classes (For Complex Validation)

Create dedicated validator classes for complex business rules that require dependencies or async operations.

### Implementation Pattern

```dart
@injectable
class TodoValidator {
  final TagsRepo _tagsRepo;

  TodoValidator(this._tagsRepo);

  Future<String?> validateCreate(Todo todo) async {
    // Basic validation
    if (todo.title.trim().isEmpty) {
    // Basic validation using Validators helper
    final basicError = Validators.combine([
      () => Validators.required(todo.title, fieldName: 'Title'),
      () => Validators.lengthBetween(todo.title, 1, 200, fieldName: 'Title'),
    ]);
    if (basicError != null) return basicError;    for (final tagId in todo.tagIds) {
      final result = await _tagsRepo.get(tagId);
      if (result is Error) {
        return "Tag $tagId does not exist";
      }
    }

    return null;
  }

  Future<String?> validateUpdate(Todo original, Todo updated) async {
    // Can compare old vs new for update-specific rules
    final basicValidation = await validateCreate(updated);
    if (basicValidation != null) return basicValidation;

    // Update-specific rules
    if (updated.completed && !original.completed) {
      // Rules when marking as complete
      if (updated.tagIds.isEmpty) {
        return "Cannot complete a todo without tags";
      }
    }

    return null;
  }
}
```

### Usage in UseCase

```dart
@injectable
class CreateTodo extends CreateEntity<Todo> {
  final TodoValidator _validator;

  CreateTodo({
    required super.eventBus,
    required TodoValidator validator,
  }) : _validator = validator;

  @override
  Future<Result<Todo>> call(Todo entity) async {
    final error = await _validator.validateCreate(entity);
    if (error != null) {
      return Result.error(UserException(message: error));
    }
    return super.call(entity);
  }
}
```

### Use Cases for Validator Classes
- Cross-entity validation (checking references)
- Async validation (database lookups)
- Complex business rules spanning multiple fields
- Rules that require injected dependencies
- Validation that differs between create/update operations

## 4. Repository-Level Validation (Data Constraints)

For data-layer constraints like uniqueness and referential integrity.

### Implementation Pattern

```dart
@Singleton(as: EntityRepo<Todo>)
class FakeTodosRepo extends FakeEntityRepo<Todo> {
  @override
  Future<Result<Todo>> create(Todo entity) async {
    // Check for duplicate titles
    final existing = entities.where((e) =>
      e.title.toLowerCase() == entity.title.toLowerCase()
    );
    if (existing.isNotEmpty) {
      return Result.error(
        UserException(message: "A todo with this title already exists")
      );
    }

    return super.create(entity);
  }
}
```

### When to Use
- Uniqueness constraints
- Foreign key validation
- Database-specific constraints
- Data integrity checks

## 5. ValidationException Type (Optional Enhancement)

Create a specific exception type for validation errors with field-level details.

### Implementation Pattern

```dart
class ValidationException extends UserException {
  final Map<String, String> fieldErrors;

  ValidationException({
    required String message,
    this.fieldErrors = const {},
  }) : super(message: message);

  // Factory for single field error
  factory ValidationException.field(String field, String error) {
    return ValidationException(
      message: error,
      fieldErrors: {field: error},
    );
  }

  // Factory for multiple field errors
  factory ValidationException.fields(Map<String, String> errors) {
    return ValidationException(
      message: errors.values.first,
      fieldErrors: errors,
    );
  }
}
```

### Usage Example

```dart
String? _validate(Todo todo) {
  final errors = <String, String>{};

  if (todo.title.trim().isEmpty) {
    errors['title'] = 'Title cannot be empty';
  }
  if (todo.title.length > 200) {
    errors['title'] = 'Title must be 200 characters or less';
  }
  if (todo.tagIds.length > 10) {
    errors['tagIds'] = 'Cannot assign more than 10 tags';
  }

  if (errors.isNotEmpty) {
    throw ValidationException.fields(errors);
  }

  return null;
}
```

### Benefits
- Field-specific error messages
- Can show errors next to form fields in UI
- Better error reporting and debugging

## Recommended Implementation Strategy

**Combine approaches 1 & 2 as the primary pattern:**

### 1. Entity-Level Validation (Simple Rules)
Add `validate()` methods to entities for field-level rules:
- Non-null checks
- Length constraints
- Format validation
- Range checks

### 2. UseCase-Level Validation (Business Rules)
Extend UseCases to add business logic validation:
- Cross-field dependencies
- State-dependent rules
- Business constraints

### 3. Repository-Level Validation (Data Integrity)
Only for data-layer concerns:
- Uniqueness constraints
- Foreign key checks
- Database-specific validations

### Complete Example Implementation

```dart
// 1. ENTITY VALIDATION (lib/features/todos/domain/entities/todo.dart)
@CopyWith()
@JsonSerializable()
class Todo extends EntityWithIdAndTimestamps {
  final String title;
  final bool completed;
  final List<String> tagIds;

  // ... existing code ...

  /// Provides validation rules for this entity
  @override
  List<String? Function()> get validators => [
    () => Validators.required(title, fieldName: 'Title'),
    () => Validators.lengthBetween(title, 1, 200, fieldName: 'Title'),
  ];
}

// 2. USECASE VALIDATION (lib/features/todos/domain/usecases/create_todo.dart)
@injectable
class CreateTodo extends CreateEntity<Todo> {
  CreateTodo({required super.eventBus});

  @override
  Future<Result<Todo>> call(Todo entity) async {
    // Entity validation first
    final validationResult = entity.validate();
    if (!validationResult.isValid) {
      return Result.error(
        UserException(message: validationResult.firstError!)
      );
    }

    // Business logic validation
    if (entity.tagIds.length > 5) {
      return Result.error(
        UserException(message: "Cannot assign more than 5 tags to a todo")
      );
    }

    // All valid - proceed with creation
    return super.call(entity);
  }
}
  CreateTodo({required super.eventBus});

  @override
  Future<Result<Todo>> call(Todo entity) async {
    // Entity validation first
    final entityError = entity.validate();
    if (entityError != null) {
      return Result.error(UserException(message: entityError));
    }

    // Business logic validation
    if (entity.tagIds.length > 5) {
      return Result.error(
        UserException(message: "Cannot assign more than 5 tags to a todo")
      );
    }

    // All valid - proceed with creation
    return super.call(entity);
  }
}

// 3. REPOSITORY VALIDATION (lib/features/todos/data/repositories/fake_todos_repo.dart)
@Singleton(as: EntityRepo<Todo>)
class FakeTodosRepo extends FakeEntityRepo<Todo> {
  @override
  Future<Result<Todo>> create(Todo entity) async {
    // Check for uniqueness
    final duplicate = entities.where((e) =>
      e.title.toLowerCase() == entity.title.toLowerCase() &&
      !e.completed
    );

    if (duplicate.isNotEmpty) {
      return Result.error(
        UserException(
          message: "An active todo with this title already exists"
        )
      );
    }

    return super.create(entity);
  }
}
```

## Integration with Existing Architecture

### Error Handling Flow

1. **Validation fails in UseCase** → Returns `Result.error(UserException)`
2. **Cubit receives error** → Pattern matches on `Error` case
3. **Error message displayed** → `Error.sanitizedErrorMessage` provides user-friendly text
4. **No event emitted** → Repository never called, no optimistic updates

### Example Cubit Integration

The existing `EntityCubit.create()` method already handles this pattern:

```dart
Future<void> create(T entity, {String? successMessage}) async {
  await lock.synchronized(() async {
    // ... existing code ...
    final result = await createEntity(entity);

    switch (result) {
      case Ok<T>():
        // Success path - entity created
        emit(currentState.createEntity(result.value)
            .copyWith(status: EntityStateStatus.updated));
      case Error<T>():
        // Validation error caught here
        onError(result.error, result.error.stackTrace ?? StackTrace.current);
        emit(currentState.copyWith(
          message: result.sanitizedErrorMessage,  // Shows validation error
          status: EntityStateStatus.error,
        ));
    }
  });
}
```

### UI Form Integration

Forms already use `flutter_form_builder` which provides client-side validation. Server-side validation in UseCases acts as a second layer:

```dart
// In TodoForm widget
void _onSave() async {
  // Client-side validation (form_builder_validators)
  if (!_formKey.currentState!.saveAndValidate()) {
    return;  // Shows form field errors
  }

  // Extract validated data
  final value = _formKey.currentState!.value;
  final String title = (value["title"] ?? '').trim();

  // Server-side validation happens in UseCase
  context.read<TodosCubit>().create(Todo(title: title));

  // Errors shown via BlocListener as SnackBar
}
```

## Benefits of This Approach

1. **Validation before optimistic updates** - Invalid data never enters the UI state
2. **Consistent error handling** - All validation uses the same `Result<T>` pattern
3. **User-friendly errors** - `UserException` messages are shown directly to users
4. **Layered validation** - Each layer validates its concerns
5. **Testable** - Validation logic can be tested independently
6. **Type-safe** - Errors are caught at compile time via Result pattern matching
7. **No event pollution** - Invalid entities never emit events into the system

## Testing Strategy

### Entity Validation Tests
```dart
test('Todo validation rejects empty title', () {
  final todo = Todo(title: '');
  expect(todo.validate(), equals('Title is required'));
});
```

### UseCase Validation Tests
```dart
test('CreateTodo rejects more than 5 tags', () async {
  final todo = Todo(
    title: 'Test',
    tagIds: ['1', '2', '3', '4', '5', '6'],
  );
  final result = await createTodo(todo);
  expect(result, isA<Error>());
});
```

### Repository Validation Tests
```dart
test('Repository rejects duplicate titles', () async {
  final todo1 = Todo(title: 'Duplicate');
  await repo.create(todo1);

  final todo2 = Todo(title: 'duplicate');  // Case insensitive
  final result = await repo.create(todo2);

  expect(result, isA<Error>());
});
```

## Migration Path

To implement validation in this project:

1. **Start with high-value validations**: Begin with the most critical business rules
2. **Add entity.validate() methods**: Simple field validation for all entities
3. **Extend specific UseCases**: Add business logic validation where needed
4. **Add repository validation last**: Only for data integrity concerns
5. **Test thoroughly**: Write tests at each layer
6. **Document rules**: Keep validation rules documented in entity/usecase files

## Future Enhancements

- **Validation composition**: Combine multiple validators
- **Async validation**: For database lookups or API calls
- **Conditional validation**: Rules that depend on entity state
- **Field-level errors**: Return `Map<String, String>` for form field errors
- **Validation middleware**: Generic validation pipeline for all entities
