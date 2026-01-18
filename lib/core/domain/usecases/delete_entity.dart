import 'package:architecture/core/domain/entities/entity_with_id_and_timestamps.dart';
import 'package:architecture/core/domain/events/crud.dart';
import 'package:architecture/core/domain/events/event_bus.dart';
import 'package:architecture/core/result/result.dart';
import 'package:architecture/core/usecase/usecase.dart';
import 'package:jozz_events/jozz_events.dart';

class DeleteEntity<T extends EntityWithIdAndTimestamps> extends UseCase<T, T> {
  final EventBus _eventBus;

  DeleteEntity({required EventBus eventBus}) : _eventBus = eventBus;

  @override
  Future<Result<T>> call(T entity) async {
    _eventBus.emitEvent(DeleteEntityEvent<T>(entity: entity));
    return Result.ok(entity);
  }
}
