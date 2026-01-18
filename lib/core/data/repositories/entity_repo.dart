import 'package:architecture/core/domain/entities/entity_with_id_and_timestamps.dart';
import 'package:architecture/core/domain/query_builder/query_builder.dart';
import 'package:architecture/core/domain/usecases/query_entities.dart';
import 'package:architecture/core/result/result.dart';
import 'package:injectable/injectable.dart';

@factoryMethod
abstract class EntityRepo<T extends EntityWithIdAndTimestamps> {
  Future<Result<T>> create(T entity);
  Future<Result<T>> get(String uid);
  Future<Result<QueryResponse<T>>> query(QueryBuilder request);
  Future<Result<T>> update(T entity);
  Future<Result<T>> delete(T entity);
}
