// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:architecture/core/data/repositories/entity_repo.dart' as _i437;
import 'package:architecture/core/domain/events/event_bus.dart' as _i902;
import 'package:architecture/features/tags/data/repositories/fake_tags_repo.dart'
    as _i282;
import 'package:architecture/features/tags/domain/entities/tag.dart' as _i642;
import 'package:architecture/features/tags/domain/usecases/create_tag.dart'
    as _i251;
import 'package:architecture/features/tags/domain/usecases/delete_tag.dart'
    as _i336;
import 'package:architecture/features/tags/domain/usecases/query_tags.dart'
    as _i937;
import 'package:architecture/features/tags/domain/usecases/update_tag.dart'
    as _i476;
import 'package:architecture/features/tags/presentation/cubits/tags_cubit.dart'
    as _i951;
import 'package:architecture/features/todos/data/repositories/fake_todos_repo.dart'
    as _i484;
import 'package:architecture/features/todos/domain/entites/todo.dart' as _i1061;
import 'package:architecture/features/todos/domain/usecases/create_todo.dart'
    as _i827;
import 'package:architecture/features/todos/domain/usecases/delete_todo.dart'
    as _i990;
import 'package:architecture/features/todos/domain/usecases/query_todos.dart'
    as _i205;
import 'package:architecture/features/todos/domain/usecases/update_todo.dart'
    as _i444;
import 'package:architecture/features/todos/presentation/cubits/todos_cubit.dart'
    as _i186;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i902.EventBus>(() => _i902.EventBus());
    gh.singleton<_i437.EntityRepo<_i1061.Todo>>(
      () => _i484.FakeTodosRepo(eventBus: gh<_i902.EventBus>()),
    );
    gh.singleton<_i437.EntityRepo<_i642.Tag>>(
      () => _i282.FakeTagsRepo(eventBus: gh<_i902.EventBus>()),
    );
    gh.factory<_i251.CreateTag>(
      () => _i251.CreateTag(eventBus: gh<_i902.EventBus>()),
    );
    gh.factory<_i336.DeleteTag>(
      () => _i336.DeleteTag(eventBus: gh<_i902.EventBus>()),
    );
    gh.factory<_i937.QueryTags>(
      () => _i937.QueryTags(eventBus: gh<_i902.EventBus>()),
    );
    gh.factory<_i476.UpdateTag>(
      () => _i476.UpdateTag(eventBus: gh<_i902.EventBus>()),
    );
    gh.factory<_i827.CreateTodo>(
      () => _i827.CreateTodo(eventBus: gh<_i902.EventBus>()),
    );
    gh.factory<_i990.DeleteTodo>(
      () => _i990.DeleteTodo(eventBus: gh<_i902.EventBus>()),
    );
    gh.factory<_i205.QueryTodos>(
      () => _i205.QueryTodos(eventBus: gh<_i902.EventBus>()),
    );
    gh.factory<_i444.UpdateTodo>(
      () => _i444.UpdateTodo(eventBus: gh<_i902.EventBus>()),
    );
    gh.lazySingleton<_i186.TodosCubit>(
      () => _i186.TodosCubit(
        eventBus: gh<_i902.EventBus>(),
        createEntity: gh<_i827.CreateTodo>(),
        updateEntity: gh<_i444.UpdateTodo>(),
        deleteEntity: gh<_i990.DeleteTodo>(),
        queryEntities: gh<_i205.QueryTodos>(),
      ),
    );
    gh.lazySingleton<_i951.TagsCubit>(
      () => _i951.TagsCubit(
        eventBus: gh<_i902.EventBus>(),
        createEntity: gh<_i251.CreateTag>(),
        updateEntity: gh<_i476.UpdateTag>(),
        deleteEntity: gh<_i336.DeleteTag>(),
        queryEntities: gh<_i937.QueryTags>(),
      ),
    );
    return this;
  }
}
