import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// A JSON converter that handles conversion between [DateTime] and Firestore [Timestamp].
///
/// This converter is used with the `json_serializable` package to automatically
/// convert Firestore [Timestamp] objects to Dart [DateTime] objects during
/// deserialization, and vice versa during serialization.
///
/// Usage:
/// ```dart
/// @JsonSerializable()
/// class MyModel {
///   @FirestoreTimestampConverter()
///   final DateTime createdAt;
/// }
/// ```
///
/// The converter implements [JsonConverter] and provides bidirectional conversion:
/// - [fromJson]: Converts a Firestore [Timestamp] to a [DateTime]
/// - [toJson]: Converts a [DateTime] to a Firestore [Timestamp]
class FirestoreTimestampConverter
    implements JsonConverter<DateTime, Timestamp> {
  const FirestoreTimestampConverter();

  @override
  DateTime fromJson(Timestamp json) => json.toDate();

  @override
  Timestamp toJson(DateTime object) => Timestamp.fromDate(object);
}
