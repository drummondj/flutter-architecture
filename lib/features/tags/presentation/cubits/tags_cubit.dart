import 'package:architecture/core/domain/events/crud.dart';
import 'package:architecture/core/domain/query_builder/query_builder.dart';
import 'package:architecture/core/presentation/cubits/entity_cubit.dart';
import 'package:architecture/core/presentation/cubits/entity_state.dart';
import 'package:architecture/features/tags/domain/entities/tag.dart';
import 'package:architecture/features/tags/domain/usecases/create_tag.dart';
import 'package:architecture/features/tags/domain/usecases/delete_tag.dart';
import 'package:architecture/features/tags/domain/usecases/query_tags.dart';
import 'package:architecture/features/tags/domain/usecases/update_tag.dart';
import 'package:architecture/features/todos/domain/entites/todo.dart';
import 'package:injectable/injectable.dart';
import 'package:jozz_events/jozz_events.dart';

@lazySingleton
class TagsCubit extends EntityCubit<Tag> {
  TagsCubit({
    required super.eventBus,
    required CreateTag super.createEntity,
    required UpdateTag super.updateEntity,
    required DeleteTag super.deleteEntity,
    required QueryTags super.queryEntities,
  }) : super() {
    eventBus.autoListen<CreateEntityEvent<Todo>>(this, handleCreateTodoEvent);
    eventBus.autoListen<DeleteEntityEvent<Todo>>(this, handleDeleteTodoEvent);
    eventBus.autoListen<UpdateEntityEvent<Todo>>(this, handleUpdateTodoEvent);
  }

  void handleCreateTodoEvent(CreateEntityEvent<Todo> event) {
    // When Todos are created increment Tag.todoCount for the selected tags
    for (final tag in getTagsById(event.entity.tagIds)) {
      update(tag, tag.copyWith(todoCount: tag.todoCount + 1));
    }
  }

  void handleDeleteTodoEvent(DeleteEntityEvent<Todo> event) {
    // When Todos are deleted decrement Tag.todoCount for the selected tags
    for (final tag in getTagsById(event.entity.tagIds)) {
      update(tag, tag.copyWith(todoCount: tag.todoCount - 1));
    }
  }

  void handleUpdateTodoEvent(UpdateEntityEvent<Todo> event) {
    // Increment or decrement todoCount depending on the changes
    List<String> removedTagIds = event.originalEntity.tagIds
        .where((e) => !event.newEntity.tagIds.contains(e))
        .toList();
    List<String> addedTagIds = event.newEntity.tagIds
        .where((e) => !event.originalEntity.tagIds.contains(e))
        .toList();
    for (final tag in getTagsById(removedTagIds)) {
      update(tag, tag.copyWith(todoCount: tag.todoCount - 1));
    }
    for (final tag in getTagsById(addedTagIds)) {
      update(tag, tag.copyWith(todoCount: tag.todoCount + 1));
    }
  }

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
