// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TodoCWProxy {
  Todo uid(String? uid);

  Todo createdAt(DateTime? createdAt);

  Todo updatedAt(DateTime? updatedAt);

  Todo title(String title);

  Todo completed(bool completed);

  Todo tagIds(List<String> tagIds);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Todo(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Todo(...).copyWith(id: 12, name: "My name")
  /// ```
  Todo call({
    String? uid,
    DateTime? createdAt,
    DateTime? updatedAt,
    String title,
    bool completed,
    List<String> tagIds,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfTodo.copyWith(...)` or call `instanceOfTodo.copyWith.fieldName(value)` for a single field.
class _$TodoCWProxyImpl implements _$TodoCWProxy {
  const _$TodoCWProxyImpl(this._value);

  final Todo _value;

  @override
  Todo uid(String? uid) => call(uid: uid);

  @override
  Todo createdAt(DateTime? createdAt) => call(createdAt: createdAt);

  @override
  Todo updatedAt(DateTime? updatedAt) => call(updatedAt: updatedAt);

  @override
  Todo title(String title) => call(title: title);

  @override
  Todo completed(bool completed) => call(completed: completed);

  @override
  Todo tagIds(List<String> tagIds) => call(tagIds: tagIds);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Todo(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Todo(...).copyWith(id: 12, name: "My name")
  /// ```
  Todo call({
    Object? uid = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? completed = const $CopyWithPlaceholder(),
    Object? tagIds = const $CopyWithPlaceholder(),
  }) {
    return Todo(
      uid: uid == const $CopyWithPlaceholder()
          ? _value.uid
          // ignore: cast_nullable_to_non_nullable
          : uid as String?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime?,
      title: title == const $CopyWithPlaceholder() || title == null
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      completed: completed == const $CopyWithPlaceholder() || completed == null
          ? _value.completed
          // ignore: cast_nullable_to_non_nullable
          : completed as bool,
      tagIds: tagIds == const $CopyWithPlaceholder() || tagIds == null
          ? _value.tagIds
          // ignore: cast_nullable_to_non_nullable
          : tagIds as List<String>,
    );
  }
}

extension $TodoCopyWith on Todo {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfTodo.copyWith(...)` or `instanceOfTodo.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TodoCWProxy get copyWith => _$TodoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
  uid: json['uid'] as String?,
  createdAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['createdAt'],
    const FirestoreTimestampConverter().fromJson,
  ),
  updatedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['updatedAt'],
    const FirestoreTimestampConverter().fromJson,
  ),
  title: json['title'] as String,
  completed: json['completed'] as bool? ?? false,
  tagIds:
      (json['tagIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
  'uid': instance.uid,
  'createdAt': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.createdAt,
    const FirestoreTimestampConverter().toJson,
  ),
  'updatedAt': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.updatedAt,
    const FirestoreTimestampConverter().toJson,
  ),
  'title': instance.title,
  'completed': instance.completed,
  'tagIds': instance.tagIds,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
