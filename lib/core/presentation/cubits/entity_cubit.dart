import 'package:architecture/core/domain/entities/entity_with_id_and_timestamps.dart';
import 'package:architecture/core/domain/events/crud.dart';
import 'package:architecture/core/domain/events/event_bus.dart';
import 'package:architecture/core/domain/query_builder/optimistic_entity_filter.dart';
import 'package:architecture/core/domain/query_builder/query_builder.dart';
import 'package:architecture/core/domain/usecases/create_entity.dart';
import 'package:architecture/core/domain/usecases/delete_entity.dart';
import 'package:architecture/core/domain/usecases/query_entities.dart';
import 'package:architecture/core/domain/usecases/update_entity.dart';
import 'package:architecture/core/exceptions/user_exception.dart';
import 'package:architecture/core/presentation/cubits/entity_state.dart';
import 'package:architecture/core/result/result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jozz_events/jozz_events.dart';
import 'package:synchronized/synchronized.dart';

class EntityCubit<T extends EntityWithIdAndTimestamps>
    extends Cubit<EntityState<T>>
    with JozzLifecycleMixin {
  final EventBus _eventBus;

  final CreateEntity<T> createEntity;
  final UpdateEntity<T> updateEntity;
  final DeleteEntity<T> deleteEntity;
  final QueryEntities<T> queryEntities;

  EntityCubit({
    required EventBus eventBus,
    required this.createEntity,
    required this.updateEntity,
    required this.deleteEntity,
    required this.queryEntities,
  }) : _eventBus = eventBus,
       super(EntityInitialState<T>(status: EntityStateStatus.initial)) {
    subscribe();
  }

  final lock = Lock();
  final List<String> tokenQueue = [];
  QueryBuilder? lastQuery;

  void subscribe() {
    // Update entities after they have been peristed by the repo
    // This is usually used to update the uid from the back-end
    _eventBus.autoListen<UpdateEntityAfterPersistenceEvent<T>>(this, (
      event,
    ) async {
      await handleUpdateEntityAfterPersistenceEvent(event);
    });

    // Handle errors communicating with the back-end
    _eventBus.autoListen<EntityPersistenceError<T>>(this, (event) async {
      await handleEntityPersistenceError(event);
    });

    // Listen for query results
    _eventBus.autoListen<QueryResponseEvent<T>>(this, (event) async {
      await handleQueryResponseEvent(event);
    });
  }

  Future<void> handleUpdateEntityAfterPersistenceEvent(
    UpdateEntityAfterPersistenceEvent<T> event,
  ) async {
    await lock.synchronized(() async {
      if (state is! EntityLoadedState<T>) {
        return;
      }

      EntityLoadedState<T> currentState = state as EntityLoadedState<T>;

      emit(
        EntityLoadedState(
          entities: currentState.entities
              .map((e) => (e == event.originalEntity) ? event.newEntity : e)
              .toList(),
          status: EntityStateStatus.loaded,
        ),
      );
    });
  }

  Future<void> handleEntityPersistenceError(
    EntityPersistenceError<T> event,
  ) async {
    await lock.synchronized(() async {
      if (state is! EntityLoadedState<T>) {
        return;
      }
      EntityLoadedState<T> currentState = state as EntityLoadedState<T>;

      switch (event.status) {
        case EntityPersistenceErrorStatus.couldNotCreate:
          // Remove entity from list
          emit(
            currentState.copyWith(
              entities: currentState.entities
                  .where((e) => e != event.newEntity)
                  .toList(),
              message: event.error.message,
              status: EntityStateStatus.error,
            ),
          );
          onError(event.error, event.error.stackTrace ?? StackTrace.current);
          break;
        case EntityPersistenceErrorStatus.couldNotUpdate:
          // Replace new entity with original entity
          emit(
            currentState.copyWith(
              entities: currentState.entities
                  .map((e) => e == event.newEntity! ? event.originalEntity! : e)
                  .toList(),
              message: event.error.message,
              status: EntityStateStatus.error,
            ),
          );
          onError(event.error, event.error.stackTrace ?? StackTrace.current);
          break;

        case EntityPersistenceErrorStatus.couldNotDelete:
          // Re-insert original entity
          emit(
            currentState.copyWith(
              entities: currentState.entities + [event.originalEntity!],
              message: event.error.message,
              status: EntityStateStatus.error,
            ),
          );
          onError(event.error, event.error.stackTrace ?? StackTrace.current);
          break;
      }
    });
  }

  Future<void> handleQueryResponseEvent(QueryResponseEvent<T> event) async {
    await lock.synchronized(() async {
      // Check if token was request by this cubit, return if not
      if (!tokenQueue.contains(event.requestEvent.token)) {
        return;
      }

      // Remove token from queue
      tokenQueue.remove(event.requestEvent.token);

      // Emit new state with updated entities
      emit(
        EntityLoadedState(
          entities: List.from(event.response.entities),
          status: EntityStateStatus.loaded,
        ),
      );
    });
  }

  Future<void> handleUpdateEntityEvent(UpdateEntityEvent<T> event) async {
    await update(event.entity);
  }

  Future<void> create(T entity, {String? successMessage}) async {
    await lock.synchronized(() async {
      if (state is! EntityLoadedState<T>) {
        return;
      }
      EntityLoadedState<T> currentState = state as EntityLoadedState<T>;
      emit(
        currentState.copyWith(
          status: EntityStateStatus.updating,
          message: null,
        ),
      );
      final result = await createEntity(entity);
      refreshLastQuery();
      switch (result) {
        case Ok<T>():
          emit(
            currentState.copyWith(
              message: successMessage ?? "${entity.runtimeType} created",
              entities: currentState.entities + [result.value],
              status: EntityStateStatus.updated,
            ),
          );
        case Error<T>():
          onError(result.error, result.error.stackTrace ?? StackTrace.current);
          emit(
            currentState.copyWith(
              message: result.sanitizedErrorMessage,
              status: EntityStateStatus.error,
            ),
          );
      }
    });
  }

  Future<void> query(QueryBuilder request) async {
    await lock.synchronized(() async {
      EntityLoadedState<T>? loadedState;

      if (state is EntityLoadedState<T>) {
        loadedState = state as EntityLoadedState<T>;
        emit(loadedState.copyWith(status: EntityStateStatus.updating));
      } else {
        emit(EntityLoadingState(status: EntityStateStatus.loading));
      }

      // Register last query for refreshing
      lastQuery = request;

      // Do optimistic query
      if (loadedState != null) {
        emit(
          loadedState.copyWith(
            entities: OptimisticEntityFilter.query<T>(
              request,
              loadedState.entities,
            ),
            status: EntityStateStatus.updating,
          ),
        );
      }

      final result = await queryEntities(request);
      switch (result) {
        case Ok<String>():
          // Add token to queue and wait
          tokenQueue.add(result.value);
        case Error<String>():
          onError(result.error, result.error.stackTrace ?? StackTrace.current);
          emit(
            EntityErrorState(
              status: EntityStateStatus.error,
              error: UserException(message: result.sanitizedErrorMessage),
            ),
          );
      }
    });
  }

  Future<void> refreshLastQuery() async {
    if (lastQuery != null) {
      await query(lastQuery!);
    }
  }

  Future<void> update(T entity, {String? successMessage}) async {
    await lock.synchronized(() async {
      if (state is! EntityLoadedState<T>) {
        return;
      }
      EntityLoadedState<T> currentState = state as EntityLoadedState<T>;
      emit(
        currentState.copyWith(
          status: EntityStateStatus.updating,
          message: null,
        ),
      );
      final result = await updateEntity(entity);
      refreshLastQuery();

      switch (result) {
        case Ok<T>():
          emit(
            currentState.copyWith(
              message: successMessage ?? "${entity.runtimeType} updated",
              entities: currentState.entities
                  .map((e) => e.uid == result.value.uid ? result.value : e)
                  .toList(),
              status: EntityStateStatus.updated,
            ),
          );
        case Error<T>():
          onError(result.error, result.error.stackTrace ?? StackTrace.current);
          emit(
            currentState.copyWith(
              message: result.sanitizedErrorMessage,
              status: EntityStateStatus.error,
            ),
          );
      }
    });
  }

  Future<void> delete(T entity, {String? successMessage}) async {
    await lock.synchronized(() async {
      if (state is! EntityLoadedState<T>) {
        return;
      }
      EntityLoadedState<T> currentState = state as EntityLoadedState<T>;
      emit(
        currentState.copyWith(
          status: EntityStateStatus.updating,
          message: null,
        ),
      );
      final result = await deleteEntity(entity);
      refreshLastQuery();
      switch (result) {
        case Ok<T>():
          emit(
            currentState.copyWith(
              message: successMessage ?? "${entity.runtimeType} deleted",
              entities: currentState.entities
                  .where((e) => e.uid != result.value.uid)
                  .toList(),
              status: EntityStateStatus.updated,
            ),
          );
        case Error<T>():
          onError(result.error, result.error.stackTrace ?? StackTrace.current);
          emit(
            currentState.copyWith(
              message: result.sanitizedErrorMessage,
              status: EntityStateStatus.error,
            ),
          );
      }
    });
  }

  @override
  Future<void> close() {
    disposeJozzSubscriptions();
    return super.close();
  }
}
