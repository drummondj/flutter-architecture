// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EntityLoadedStateCWProxy<
  T extends EntityWithIdAndTimestamps<dynamic>
> {
  EntityLoadedState<T> entities(List<T> entities);

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
    List<T> entities,
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
  EntityLoadedState<T> entities(List<T> entities) => call(entities: entities);

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
    Object? entities = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
  }) {
    return EntityLoadedState<T>(
      entities: entities == const $CopyWithPlaceholder() || entities == null
          ? _value.entities
          // ignore: cast_nullable_to_non_nullable
          : entities as List<T>,
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
