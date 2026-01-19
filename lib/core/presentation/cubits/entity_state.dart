import 'package:architecture/core/domain/entities/entity_with_id_and_timestamps.dart';
import 'package:architecture/core/domain/query_builder/optimistic_entity_filter.dart';
import 'package:architecture/core/domain/query_builder/query_builder.dart';
import 'package:architecture/core/domain/usecases/query_entities.dart';
import 'package:architecture/core/exceptions/app_exception.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'entity_state.g.dart';

enum EntityStateStatus { initial, loading, loaded, updating, updated, error }

@CopyWith()
class NamedQueryResult<T extends EntityWithIdAndTimestamps> {
  final String name;
  final QueryBuilder request;
  final List<T> entities;
  const NamedQueryResult({
    required this.name,
    required this.request,
    required this.entities,
  });

  NamedQueryResult<T> updateEntity(T newEntity) {
    return copyWith(
      entities: entities
          .map((e) => (e.uid == newEntity.uid) ? newEntity : e)
          .toList(),
    ).optimisticFilter();
  }

  NamedQueryResult<T> updateEntityWithoutId(T originalEntity, T newEntity) {
    return copyWith(
      entities: entities
          .map((e) => (e == originalEntity) ? newEntity : e)
          .toList(),
    ).optimisticFilter();
  }

  NamedQueryResult<T> deleteEntity(T entity) {
    return copyWith(
      entities: entities.where((e) => e != entity).toList(),
    ).optimisticFilter();
  }

  NamedQueryResult<T> createEntity(T entity) {
    return copyWith(entities: entities + [entity]).optimisticFilter();
  }

  NamedQueryResult<T> optimisticFilter() {
    return copyWith(
      entities: OptimisticEntityFilter.query<T>(request, entities),
    );
  }

  factory NamedQueryResult.fromQueryResponse(QueryResponse<T> response) {
    return NamedQueryResult<T>(
      name: response.request.name,
      request: response.request,
      entities: response.entities,
    );
  }
}

sealed class EntityState<T extends EntityWithIdAndTimestamps>
    extends Equatable {
  final EntityStateStatus status;
  final String? message;

  const EntityState({required this.status, this.message});

  @override
  List<Object?> get props => [status, message];

  @override
  String toString() {
    return "$runtimeType: status = ${status.name}";
  }
}

class EntityInitialState<T extends EntityWithIdAndTimestamps>
    extends EntityState<T> {
  const EntityInitialState({required super.status, super.message});
}

class EntityLoadingState<T extends EntityWithIdAndTimestamps>
    extends EntityState<T> {
  const EntityLoadingState({required super.status, super.message});
}

@CopyWith()
class EntityLoadedState<T extends EntityWithIdAndTimestamps>
    extends EntityState<T> {
  final Map<String, NamedQueryResult<T>> searchResults;

  const EntityLoadedState({
    required this.searchResults,
    required super.status,
    super.message,
  });

  @override
  List<Object?> get props => [...super.props, searchResults];

  EntityLoadedState<T> updateEntity(T newEntity) {
    final updatedSearchResults = searchResults.map(
      (key, value) => MapEntry(key, value.updateEntity(newEntity)),
    );
    return copyWith(searchResults: updatedSearchResults);
  }

  EntityLoadedState<T> updateEntityWithoutId(T originalEntity, T newEntity) {
    final updatedSearchResults = searchResults.map(
      (key, value) =>
          MapEntry(key, value.updateEntityWithoutId(originalEntity, newEntity)),
    );
    return copyWith(searchResults: updatedSearchResults);
  }

  EntityLoadedState<T> deleteEntity(T entity) {
    final updatedSearchResults = searchResults.map(
      (key, value) => MapEntry(key, value.deleteEntity(entity)),
    );
    return copyWith(searchResults: updatedSearchResults);
  }

  EntityLoadedState<T> createEntity(T entity) {
    final updatedSearchResults = searchResults.map(
      (key, value) => MapEntry(key, value.createEntity(entity)),
    );
    return copyWith(searchResults: updatedSearchResults);
  }

  EntityLoadedState<T> addSearchResult(QueryResponse<T> response) {
    NamedQueryResult<T> namedQueryResult =
        NamedQueryResult<T>.fromQueryResponse(response);
    return copyWith(
      searchResults: {
        ...searchResults,
        namedQueryResult.name: namedQueryResult,
      },
    );
  }

  NamedQueryResult<T>? getSearchResultByName(String name) {
    return searchResults[name];
  }
}

class EntityErrorState<T extends EntityWithIdAndTimestamps>
    extends EntityState<T> {
  final AppException error;
  const EntityErrorState({
    required super.status,
    super.message,
    required this.error,
  });
}
