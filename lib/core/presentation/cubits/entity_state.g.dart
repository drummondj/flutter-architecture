// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$NamedQueryResultCWProxy<
  T extends EntityWithIdAndTimestamps<dynamic>
> {
  NamedQueryResult<T> name(String name);

  NamedQueryResult<T> request(QueryBuilder request);

  NamedQueryResult<T> entities(List<T> entities);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `NamedQueryResult<T>(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// NamedQueryResult<T>(...).copyWith(id: 12, name: "My name")
  /// ```
  NamedQueryResult<T> call({
    String name,
    QueryBuilder request,
    List<T> entities,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfNamedQueryResult.copyWith(...)` or call `instanceOfNamedQueryResult.copyWith.fieldName(value)` for a single field.
class _$NamedQueryResultCWProxyImpl<
  T extends EntityWithIdAndTimestamps<dynamic>
>
    implements _$NamedQueryResultCWProxy<T> {
  const _$NamedQueryResultCWProxyImpl(this._value);

  final NamedQueryResult<T> _value;

  @override
  NamedQueryResult<T> name(String name) => call(name: name);

  @override
  NamedQueryResult<T> request(QueryBuilder request) => call(request: request);

  @override
  NamedQueryResult<T> entities(List<T> entities) => call(entities: entities);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `NamedQueryResult<T>(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// NamedQueryResult<T>(...).copyWith(id: 12, name: "My name")
  /// ```
  NamedQueryResult<T> call({
    Object? name = const $CopyWithPlaceholder(),
    Object? request = const $CopyWithPlaceholder(),
    Object? entities = const $CopyWithPlaceholder(),
  }) {
    return NamedQueryResult<T>(
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      request: request == const $CopyWithPlaceholder() || request == null
          ? _value.request
          // ignore: cast_nullable_to_non_nullable
          : request as QueryBuilder,
      entities: entities == const $CopyWithPlaceholder() || entities == null
          ? _value.entities
          // ignore: cast_nullable_to_non_nullable
          : entities as List<T>,
    );
  }
}

extension $NamedQueryResultCopyWith<
  T extends EntityWithIdAndTimestamps<dynamic>
>
    on NamedQueryResult<T> {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfNamedQueryResult.copyWith(...)` or `instanceOfNamedQueryResult.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$NamedQueryResultCWProxy<T> get copyWith =>
      _$NamedQueryResultCWProxyImpl<T>(this);
}

abstract class _$EntityLoadedStateCWProxy<
  T extends EntityWithIdAndTimestamps<dynamic>
> {
  EntityLoadedState<T> searchResults(
    Map<String, NamedQueryResult<T>> searchResults,
  );

  EntityLoadedState<T> status(EntityStateStatus status);

  EntityLoadedState<T> message(String? message);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EntityLoadedState<T>(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EntityLoadedState<T>(...).copyWith(id: 12, name: "My name")
  /// ```
  EntityLoadedState<T> call({
    Map<String, NamedQueryResult<T>> searchResults,
    EntityStateStatus status,
    String? message,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfEntityLoadedState.copyWith(...)` or call `instanceOfEntityLoadedState.copyWith.fieldName(value)` for a single field.
class _$EntityLoadedStateCWProxyImpl<
  T extends EntityWithIdAndTimestamps<dynamic>
>
    implements _$EntityLoadedStateCWProxy<T> {
  const _$EntityLoadedStateCWProxyImpl(this._value);

  final EntityLoadedState<T> _value;

  @override
  EntityLoadedState<T> searchResults(
    Map<String, NamedQueryResult<T>> searchResults,
  ) => call(searchResults: searchResults);

  @override
  EntityLoadedState<T> status(EntityStateStatus status) => call(status: status);

  @override
  EntityLoadedState<T> message(String? message) => call(message: message);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EntityLoadedState<T>(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EntityLoadedState<T>(...).copyWith(id: 12, name: "My name")
  /// ```
  EntityLoadedState<T> call({
    Object? searchResults = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
  }) {
    return EntityLoadedState<T>(
      searchResults:
          searchResults == const $CopyWithPlaceholder() || searchResults == null
          ? _value.searchResults
          // ignore: cast_nullable_to_non_nullable
          : searchResults as Map<String, NamedQueryResult<T>>,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as EntityStateStatus,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
    );
  }
}

extension $EntityLoadedStateCopyWith<
  T extends EntityWithIdAndTimestamps<dynamic>
>
    on EntityLoadedState<T> {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfEntityLoadedState.copyWith(...)` or `instanceOfEntityLoadedState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EntityLoadedStateCWProxy<T> get copyWith =>
      _$EntityLoadedStateCWProxyImpl<T>(this);
}
