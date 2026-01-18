import 'package:architecture/core/domain/entities/firestore_timestamp_converter.dart';
import 'package:equatable/equatable.dart';

/// An abstract base class for entities that have an identifier and timestamp fields.
///
/// This class extends [Equatable] to provide value equality comparison based on
/// the entity's properties. Classes extending this should typically include:
/// - An identifier field (e.g., `id`)
/// - Timestamp fields (e.g., `createdAt`, `updatedAt`)
///
/// Example:
/// ```dart
/// class User extends EntityWithIdAndTimestamps {
///   final String name;
///
///   const User({
///     required super.id,
///     required super.createdAt,
///     super.updatedAt,
///     required this.name,
///   });
///
///   @override
///   List<Object?> get props => [...super.props, name];
/// }
/// ```
abstract class EntityWithIdAndTimestamps<T> extends Equatable {
  final String? uid;

  @FirestoreTimestampConverter()
  final DateTime? createdAt;

  @FirestoreTimestampConverter()
  final DateTime? updatedAt;

  const EntityWithIdAndTimestamps({
    this.uid,
    required this.createdAt,
    this.updatedAt,
  });

  T updateFields({String? uid, DateTime? createdAt, DateTime? updatedAt});

  @override
  List<Object?> get props => [uid, createdAt, updatedAt];

  Map<String, dynamic> toJson();
}
