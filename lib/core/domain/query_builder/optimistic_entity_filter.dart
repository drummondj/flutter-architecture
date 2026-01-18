import 'package:architecture/core/domain/entities/entity_with_id_and_timestamps.dart';
import 'package:architecture/core/domain/query_builder/query_builder.dart';
import 'package:architecture/core/exceptions/internal_exception.dart';

class OptimisticEntityFilter<T extends EntityWithIdAndTimestamps> {
  static List<T> query<T extends EntityWithIdAndTimestamps>(
    QueryBuilder request,
    List<T> entities,
  ) {
    List<T> filtered = entities;

    // Apply where conditions
    for (WhereSpecification where in request.wheres) {
      filtered = filtered.where((entry) {
        final json = entry.toJson();

        if (!json.containsKey(where.field)) {
          throw InternalException(
            message:
                "Query on unknown field '${where.field}' in ${entry.runtimeType} object",
            stackTrace: StackTrace.current,
          );
        }

        final fieldValue = json[where.field];

        return switch (where.condition) {
          WhereCondition.equals => fieldValue == where.value,
          WhereCondition.greaterThan =>
            fieldValue is num &&
                where.value is num &&
                fieldValue > (where.value as num),
          WhereCondition.lessThan =>
            fieldValue is num &&
                where.value is num &&
                fieldValue < (where.value as num),
          WhereCondition.contains =>
            fieldValue is String &&
                where.value is String &&
                fieldValue.contains(where.value as String),
          WhereCondition.isNull =>
            where.value == true ? fieldValue == null : fieldValue != null,
          WhereCondition.arrayContainsAny =>
            fieldValue is List &&
                where.value is List &&
                (where.value as List).any((item) => fieldValue.contains(item)),
          WhereCondition.whereIn =>
            where.value is List && (where.value as List).contains(fieldValue),
        };
      }).toList();
    }

    // Apply ordering
    if (request.orderBys.isNotEmpty) {
      filtered = List.from(filtered);
      for (final orderBy in request.orderBys.reversed) {
        filtered.sort((a, b) {
          final aJson = a.toJson();
          final bJson = b.toJson();

          if (!aJson.containsKey(orderBy.field) ||
              !bJson.containsKey(orderBy.field)) {
            return 0;
          }

          final aValue = aJson[orderBy.field];
          final bValue = bJson[orderBy.field];

          int comparison;
          if (aValue == null && bValue == null) {
            comparison = 0;
          } else if (aValue == null) {
            comparison = -1;
          } else if (bValue == null) {
            comparison = 1;
          } else if (aValue is Comparable && bValue is Comparable) {
            comparison = (aValue).compareTo(bValue);
          } else {
            comparison = 0;
          }

          return orderBy.descending ? -comparison : comparison;
        });
      }
    }

    // Apply limit
    final limit = request.limitValue ?? 50;
    return filtered.take(limit).toList();
  }
}
