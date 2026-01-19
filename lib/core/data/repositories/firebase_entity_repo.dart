import 'package:architecture/core/data/repositories/entity_repo.dart';
import 'package:architecture/core/domain/entities/entity_with_id_and_timestamps.dart';
import 'package:architecture/core/domain/query_builder/query_builder.dart';
import 'package:architecture/core/domain/usecases/query_entities.dart';
import 'package:architecture/core/result/result.dart';
import 'package:jozz_events/jozz_events.dart';

class FirebaseEntityRepo<T extends EntityWithIdAndTimestamps>
    with JozzLifecycleMixin
    implements EntityRepo<T> {
  @override
  Future<Result<T>> create(T entity) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Result<T>> delete(T entity) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Result<T>> get(String uid) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<Result<QueryResponse<T>>> query(QueryBuilder request) {
    // TODO: implement query
    throw UnimplementedError();
  }

  @override
  Future<Result<T>> update(T entity) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
