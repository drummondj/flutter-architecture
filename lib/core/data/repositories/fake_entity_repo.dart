import 'package:architecture/core/data/repositories/entity_repo.dart';
import 'package:architecture/core/domain/entities/entity_with_id_and_timestamps.dart';
import 'package:architecture/core/domain/events/crud.dart';
import 'package:architecture/core/domain/events/event_bus.dart';
import 'package:architecture/core/domain/query_builder/optimistic_entity_filter.dart';
import 'package:architecture/core/domain/query_builder/query_builder.dart';
import 'package:architecture/core/domain/usecases/query_entities.dart';
import 'package:architecture/core/exceptions/internal_exception.dart';
import 'package:architecture/core/exceptions/user_exception.dart';
import 'package:architecture/core/result/result.dart';
import 'package:jozz_events/jozz_events.dart';

class FakeEntityRepo<T extends EntityWithIdAndTimestamps>
    with JozzLifecycleMixin
    implements EntityRepo<T> {
  final EventBus _eventBus;
  final List<T> entities = [];

  FakeEntityRepo({required EventBus eventBus}) : _eventBus = eventBus {
    _eventBus.autoListen<CreateEntityEvent<T>>(this, (event) async {
      final result = await create(event.entity);
      switch (result) {
        case Ok<T>():
          _eventBus.emitEvent(
            UpdateEntityAfterPersistenceEvent<T>(
              originalEntity: event.entity,
              newEntity: result.value,
            ),
          );
        case Error<T>():
          _eventBus.emitEvent(
            EntityPersistenceError<T>(
              status: EntityPersistenceErrorStatus.couldNotCreate,
              newEntity: event.entity,
              error: result.error,
            ),
          );
      }
    });
    _eventBus.autoListen<QueryRequestEvent<T>>(this, (event) async {
      final result = await query(event.request);
      switch (result) {
        case Ok<QueryResponse<T>>():
          _eventBus.emitEvent(
            QueryResponseEvent<T>(response: result.value, requestEvent: event),
          );
        case Error<QueryResponse<T>>():
          _eventBus.emitEvent(
            QueryErrorEvent<T>(requestEvent: event, error: result.error),
          );
      }
    });
    _eventBus.autoListen<UpdateEntityEvent<T>>(this, (event) async {
      final result = await update(event.newEntity);
      switch (result) {
        case Ok<T>():
          _eventBus.emitEvent(
            UpdateEntityAfterPersistenceEvent<T>(
              originalEntity: event.newEntity,
              newEntity: result.value,
            ),
          );
        case Error<T>():
          _eventBus.emitEvent(
            EntityPersistenceError<T>(
              status: EntityPersistenceErrorStatus.couldNotCreate,
              newEntity: event.newEntity,
              error: result.error,
            ),
          );
      }
    });
    _eventBus.autoListen<DeleteEntityEvent<T>>(this, (event) async {
      final result = await delete(event.entity);
      switch (result) {
        case Ok<T>():
          _eventBus.emitEvent(
            UpdateEntityAfterPersistenceEvent<T>(
              originalEntity: event.entity,
              newEntity: result.value,
            ),
          );
        case Error<T>():
          _eventBus.emitEvent(
            EntityPersistenceError<T>(
              status: EntityPersistenceErrorStatus.couldNotCreate,
              newEntity: event.entity,
              error: result.error,
            ),
          );
      }
    });
  }

  Future<void> _simulatedDelay() async {
    await Future.delayed(Duration(milliseconds: 200));
  }

  @override
  Future<Result<T>> create(T entity) async {
    await _simulatedDelay();
    try {
      T withId = entity.updateFields(
        uid: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
      );
      entities.add(withId);
      return Result.ok(withId);
    } catch (e, stackTrace) {
      return Result.error(
        InternalException(
          message: "Failed to create entity",
          stackTrace: stackTrace,
          cause: e,
        ),
      );
    }
  }

  @override
  Future<Result<QueryResponse<T>>> query(QueryBuilder request) async {
    await _simulatedDelay();
    try {
      List<T> filtered = OptimisticEntityFilter.query<T>(request, entities);
      final response = QueryResponse<T>(request: request, entities: filtered);
      return Result.ok(response);
    } catch (e, stackTrace) {
      return Result.error(
        InternalException(
          message: "Failed to query entities",
          stackTrace: stackTrace,
          cause: e,
        ),
      );
    }
  }

  @override
  Future<Result<T>> update(T entity) async {
    await _simulatedDelay();
    try {
      final index = entities.indexWhere((e) => e.uid == entity.uid);

      if (index == -1) {
        return Result.error(
          UserException(message: "T ${entity.uid} not found"),
        );
      }

      entities[index] = entity.updateFields(updatedAt: DateTime.now());
      return Result.ok(entities[index]);
    } catch (e, stackTrace) {
      return Result.error(
        InternalException(
          message: "Failed to update entity",
          stackTrace: stackTrace,
          cause: e,
        ),
      );
    }
  }

  @override
  Future<Result<T>> delete(T entity) async {
    await _simulatedDelay();
    try {
      if (entities.remove(entity)) {
        return Result.ok(entity);
      } else {
        return Result.error(
          UserException(message: "Entity ${entity.uid} does not exist"),
        );
      }
    } catch (e, stackTrace) {
      return Result.error(
        InternalException(
          message: "Failed to delete entity ${entity.uid}",
          stackTrace: stackTrace,
          cause: e,
        ),
      );
    }
  }

  @override
  Future<Result<T>> get(String uid) async {
    await _simulatedDelay();
    try {
      final entity = entities.where((e) => e.uid == uid).firstOrNull;
      if (entity == null) {
        return Result.error(
          UserException(message: "Entity $uid does not exist"),
        );
      }
      return Result.ok(entity);
    } catch (e, stackTrace) {
      return Result.error(
        InternalException(
          message: "Failed to find entity $uid",
          stackTrace: stackTrace,
          cause: e,
        ),
      );
    }
  }
}
