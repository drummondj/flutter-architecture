import 'package:architecture/core/domain/usecases/query_entities.dart';
import 'package:architecture/features/tags/domain/entities/tag.dart';
import 'package:injectable/injectable.dart';

@injectable
class QueryTags extends QueryEntities<Tag> {
  QueryTags({required super.eventBus});
}
