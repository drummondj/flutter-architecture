import 'package:architecture/core/data/repositories/entity_repo.dart';
import 'package:architecture/core/data/repositories/fake_entity_repo.dart';
import 'package:architecture/features/tags/domain/entities/tag.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: EntityRepo<Tag>)
class FakeTagsRepo extends FakeEntityRepo<Tag> {
  FakeTagsRepo({required super.eventBus}) : super() {
    entities.addAll([
      Tag(uid: "1", name: "Personal"),
      Tag(uid: "2", name: "Work"),
    ]);
  }
}
