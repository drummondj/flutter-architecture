import 'package:architecture/core/domain/entities/entity_with_id_and_timestamps.dart';
import 'package:architecture/core/domain/events/crud.dart';
import 'package:architecture/core/domain/events/event_bus.dart';
import 'package:architecture/core/domain/validation/validation_result.dart';
import 'package:architecture/core/exceptions/validation_exception.dart';
import 'package:architecture/core/result/result.dart';
import 'package:architecture/core/usecase/usecase.dart';
import 'package:jozz_events/jozz_events.dart';

class CreateEntity<T extends EntityWithIdAndTimestamps> extends UseCase<T, T> {
  final EventBus _eventBus;

  CreateEntity({required EventBus eventBus}) : _eventBus = eventBus;

  @override
  Future<Result<T>> call(T entity) async {
    final validationResult = entity.validate();
    if (validationResult.status == ValidationStatus.fail) {
      return Result.error(
        ValidationException(
          message: validationResult.errors.join("\n"),
          validationResult: validationResult,
        ),
      );
    }
    _eventBus.emitEvent(CreateEntityEvent<T>(entity: entity));
    return Result.ok(entity);
  }
}
