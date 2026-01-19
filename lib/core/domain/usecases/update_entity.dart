import 'package:architecture/core/domain/entities/entity_with_id_and_timestamps.dart';
import 'package:architecture/core/domain/events/crud.dart';
import 'package:architecture/core/domain/events/event_bus.dart';
import 'package:architecture/core/domain/validation/validation_result.dart';
import 'package:architecture/core/exceptions/validation_exception.dart';
import 'package:architecture/core/result/result.dart';
import 'package:architecture/core/usecase/usecase.dart';
import 'package:jozz_events/jozz_events.dart';

class UpdateEntity<T extends EntityWithIdAndTimestamps>
    extends UseCase<T, UpdateEntityParams<T>> {
  final EventBus _eventBus;

  UpdateEntity({required EventBus eventBus}) : _eventBus = eventBus;

  @override
  Future<Result<T>> call(UpdateEntityParams<T> params) async {
    final validationResult = params.newEntity.validate();
    if (validationResult.status == ValidationStatus.fail) {
      return Result.error(
        ValidationException(
          message: validationResult.errors.join("\n"),
          validationResult: validationResult,
        ),
      );
    }
    _eventBus.emitEvent(
      UpdateEntityEvent<T>(
        originalEntity: params.originalEntity,
        newEntity: params.newEntity,
      ),
    );
    return Result.ok(params.newEntity);
  }
}

class UpdateEntityParams<T extends EntityWithIdAndTimestamps> {
  final T originalEntity;
  final T newEntity;

  const UpdateEntityParams({
    required this.originalEntity,
    required this.newEntity,
  });
}
