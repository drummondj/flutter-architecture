import 'package:architecture/core/domain/entities/entity_with_id_and_timestamps.dart';
import 'package:architecture/core/domain/query_builder/query_builder.dart';
import 'package:architecture/core/domain/usecases/query_entities.dart';
import 'package:architecture/core/exceptions/app_exception.dart';
import 'package:jozz_events/jozz_events.dart';

class CreateEntityEvent<T extends EntityWithIdAndTimestamps> extends JozzEvent {
  final T entity;
  const CreateEntityEvent({required this.entity});
}

class QueryRequestEvent<T extends EntityWithIdAndTimestamps> extends JozzEvent {
  final String token;
  final QueryBuilder request;

  QueryRequestEvent({required this.token, required this.request});
}

class QueryResponseEvent<T extends EntityWithIdAndTimestamps>
    extends JozzEvent {
  final QueryResponse<T> response;
  final QueryRequestEvent requestEvent;

  QueryResponseEvent({required this.response, required this.requestEvent});
}

class QueryErrorEvent<T extends EntityWithIdAndTimestamps> extends JozzEvent {
  final QueryRequestEvent requestEvent;
  final AppException error;

  QueryErrorEvent({required this.error, required this.requestEvent});
}

class UpdateEntityEvent<T extends EntityWithIdAndTimestamps> extends JozzEvent {
  final T entity;
  const UpdateEntityEvent({required this.entity});
}

class DeleteEntityEvent<T extends EntityWithIdAndTimestamps> extends JozzEvent {
  final T entity;
  const DeleteEntityEvent({required this.entity});
}

class UpdateEntityAfterPersistenceEvent<T extends EntityWithIdAndTimestamps>
    extends JozzEvent {
  final T originalEntity;
  final T newEntity;
  const UpdateEntityAfterPersistenceEvent({
    required this.originalEntity,
    required this.newEntity,
  });
}

enum EntityPersistenceErrorStatus {
  couldNotCreate,
  couldNotUpdate,
  couldNotDelete,
}

class EntityPersistenceError<T extends EntityWithIdAndTimestamps>
    extends JozzEvent {
  final T? originalEntity;
  final T? newEntity;
  final AppException error;
  final EntityPersistenceErrorStatus status;
  const EntityPersistenceError({
    this.originalEntity,
    this.newEntity,
    required this.error,
    required this.status,
  }) : assert(
         status != EntityPersistenceErrorStatus.couldNotCreate ||
             (newEntity != null && originalEntity == null),
         'When status is couldNotCreate, newEntity must not be null and originalEntity must be null',
       ),
       assert(
         status != EntityPersistenceErrorStatus.couldNotUpdate ||
             (newEntity != null && originalEntity != null),
         'When status is couldNotUpdate, both newEntity and originalEntity must not be null',
       ),
       assert(
         status != EntityPersistenceErrorStatus.couldNotDelete ||
             (newEntity == null && originalEntity != null),
         'When status is couldNotDelete, originalEntity must not be null and newEntity must be null',
       );
}
