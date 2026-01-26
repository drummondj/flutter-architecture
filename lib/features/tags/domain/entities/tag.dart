import 'package:architecture/core/domain/entities/entity_with_id_and_timestamps.dart';
import 'package:architecture/core/domain/entities/firestore_timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@CopyWith()
@JsonSerializable()
class Tag extends EntityWithIdAndTimestamps<Tag> {
  final String name;
  final int todoCount;

  const Tag({
    super.uid,
    super.createdAt,
    super.updatedAt,
    required this.name,
    this.todoCount = 0,
  });

  @override
  List<Object?> get props => [...super.props, name, todoCount];

  @override
  updateEntityFields({String? uid, DateTime? createdAt, DateTime? updatedAt}) {
    return copyWith(
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, dynamic> toJson() => _$TagToJson(this);
  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
}
