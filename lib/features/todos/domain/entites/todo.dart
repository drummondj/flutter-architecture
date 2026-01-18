import 'package:architecture/core/domain/entities/entity_with_id_and_timestamps.dart';
import 'package:architecture/core/domain/entities/firestore_timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@CopyWith()
@JsonSerializable()
class Todo extends EntityWithIdAndTimestamps {
  final String title;
  final bool completed;
  final List<String> tagIds;

  const Todo({
    super.uid,
    super.createdAt,
    super.updatedAt,
    required this.title,
    this.completed = false,
    this.tagIds = const [],
  });

  @override
  List<Object?> get props => [...super.props, title, completed];

  @override
  updateFields({String? uid, DateTime? createdAt, DateTime? updatedAt}) {
    return copyWith(
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, dynamic> toJson() => _$TodoToJson(this);
  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
