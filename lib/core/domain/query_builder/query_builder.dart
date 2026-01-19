enum WhereCondition {
  equals,
  greaterThan,
  lessThan,
  contains,
  isNull,
  arrayContainsAny,
  whereIn,
}

class WhereSpecification {
  final String field;
  final WhereCondition condition;
  final Object value;
  WhereSpecification(this.field, this.condition, this.value);
}

class OrderBySpecification {
  final String field;
  final bool descending;
  OrderBySpecification(this.field, {this.descending = false});
}

class QueryBuilder {
  final String name;

  QueryBuilder({required this.name});

  int? _limit;
  int? get limitValue => _limit;

  final List<WhereSpecification> _wheres = [];
  List<WhereSpecification> get wheres => List.unmodifiable(_wheres);

  final List<OrderBySpecification> _orderBys = [];
  List<OrderBySpecification> get orderBys => List.unmodifiable(_orderBys);

  Object? _startAfterDocument;
  Object? get startAfterDocumentValue => _startAfterDocument;

  QueryBuilder where(
    String field, {
    Object? equals,
    num? greaterThan,
    num? lessThan,
    String? contains,
    bool? isNull,
    Object? arrayContainsAny,
    List<Object>? whereIn,
  }) {
    final conditions = {
      WhereCondition.equals: equals,
      WhereCondition.greaterThan: greaterThan,
      WhereCondition.lessThan: lessThan,
      WhereCondition.contains: contains,
      WhereCondition.isNull: isNull,
      WhereCondition.arrayContainsAny: arrayContainsAny,
      WhereCondition.whereIn: whereIn,
    };

    final nonNullEntries = conditions.entries
        .where((e) => e.value != null)
        .toList();

    if (nonNullEntries.isEmpty) {
      throw ArgumentError('At least one where condition must be specified');
    }

    if (nonNullEntries.length > 1) {
      throw ArgumentError(
        'Only one where condition can be specified at a time',
      );
    }

    final entry = nonNullEntries.first;
    _wheres.add(WhereSpecification(field, entry.key, entry.value!));

    return this;
  }

  QueryBuilder orderBy(String field, {bool descending = false}) {
    _orderBys.add(OrderBySpecification(field, descending: descending));
    return this;
  }

  QueryBuilder limit(int limit) {
    _limit = limit;
    return this;
  }

  QueryBuilder startAfterDocument(Object document) {
    _startAfterDocument = document;
    return this;
  }
}
