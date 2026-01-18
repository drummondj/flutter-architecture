import 'package:architecture/core/domain/entities/entity_with_id_and_timestamps.dart';
import 'package:architecture/core/domain/events/crud.dart';
import 'package:architecture/core/domain/events/event_bus.dart';
import 'package:architecture/core/domain/query_builder/query_builder.dart';
import 'package:architecture/core/result/result.dart';
import 'package:architecture/core/usecase/usecase.dart';
import 'package:jozz_events/jozz_events.dart';
import 'package:uuid/uuid.dart';

class QueryResponse<T> {
  final QueryBuilder request;
  final List<T> entities;

  QueryResponse({required this.request, required this.entities});
}

class QueryEntities<T extends EntityWithIdAndTimestamps>
    extends UseCase<String, QueryBuilder> {
  final EventBus _eventBus;

  QueryEntities({required EventBus eventBus}) : _eventBus = eventBus;

  @override
  Future<Result<String>> call(QueryBuilder request) async {
    String token = Uuid().v4();
    _eventBus.emitEvent(QueryRequestEvent<T>(token: token, request: request));
    return Result.ok(token);
  }
}
