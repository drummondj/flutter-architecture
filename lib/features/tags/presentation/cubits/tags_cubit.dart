import 'package:architecture/core/domain/query_builder/query_builder.dart';
import 'package:architecture/core/presentation/cubits/entity_cubit.dart';
import 'package:architecture/core/presentation/cubits/entity_state.dart';
import 'package:architecture/features/tags/domain/entities/tag.dart';
import 'package:architecture/features/tags/domain/usecases/create_tag.dart';
import 'package:architecture/features/tags/domain/usecases/delete_tag.dart';
import 'package:architecture/features/tags/domain/usecases/query_tags.dart';
import 'package:architecture/features/tags/domain/usecases/update_tag.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TagsCubit extends EntityCubit<Tag> {
  TagsCubit({
    required super.eventBus,
    required CreateTag super.createEntity,
    required UpdateTag super.updateEntity,
    required DeleteTag super.deleteEntity,
    required QueryTags super.queryEntities,
  });

  Future<void> loadAllTags() async {
    await query(QueryBuilder(name: "all_tags"));
  }

  List<Tag> getAllTags() {
    if (state is EntityLoadedState<Tag>) {
      return (state as EntityLoadedState<Tag>)
              .getSearchResultByName("all_tags")
              ?.entities ??
          [];
    }
    return [];
  }

  List<Tag> getTagsById(List<String> tagIds) {
    return getAllTags().where((e) => tagIds.contains(e.uid)).toList();
  }
}
