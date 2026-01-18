// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TagCWProxy {
  Tag uid(String? uid);

  Tag createdAt(DateTime? createdAt);

  Tag updatedAt(DateTime? updatedAt);

  Tag name(String name);

  Tag todoCount(int todoCount);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Tag(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Tag(...).copyWith(id: 12, name: "My name")
  /// ```
  Tag call({
    String? uid,
    DateTime? createdAt,
    DateTime? updatedAt,
    String name,
    int todoCount,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfTag.copyWith(...)` or call `instanceOfTag.copyWith.fieldName(value)` for a single field.
class _$TagCWProxyImpl implements _$TagCWProxy {
  const _$TagCWProxyImpl(this._value);

  final Tag _value;

  @override
  Tag uid(String? uid) => call(uid: uid);

  @override
  Tag createdAt(DateTime? createdAt) => call(createdAt: createdAt);

  @override
  Tag updatedAt(DateTime? updatedAt) => call(updatedAt: updatedAt);

  @override
  Tag name(String name) => call(name: name);

  @override
  Tag todoCount(int todoCount) => call(todoCount: todoCount);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Tag(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Tag(...).copyWith(id: 12, name: "My name")
  /// ```
  Tag call({
    Object? uid = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? todoCount = const $CopyWithPlaceholder(),
  }) {
    return Tag(
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
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      todoCount: todoCount == const $CopyWithPlaceholder() || todoCount == null
          ? _value.todoCount
          // ignore: cast_nullable_to_non_nullable
          : todoCount as int,
    );
  }
}

extension $TagCopyWith on Tag {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfTag.copyWith(...)` or `instanceOfTag.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TagCWProxy get copyWith => _$TagCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
  uid: json['uid'] as String?,
  createdAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['createdAt'],
    const FirestoreTimestampConverter().fromJson,
  ),
  updatedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['updatedAt'],
    const FirestoreTimestampConverter().fromJson,
  ),
  name: json['name'] as String,
  todoCount: (json['todoCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
  'uid': instance.uid,
  'createdAt': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.createdAt,
    const FirestoreTimestampConverter().toJson,
  ),
  'updatedAt': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.updatedAt,
    const FirestoreTimestampConverter().toJson,
  ),
  'name': instance.name,
  'todoCount': instance.todoCount,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
