import 'package:architecture/core/data/repositories/entity_repo.dart';
import 'package:architecture/core/data/repositories/firebase_entity_repo.dart';
import 'package:architecture/features/todos/domain/entites/todo.dart';
import 'package:injectable/injectable.dart';

//@Singleton(as: EntityRepo<Todo>)
class FirebaseTodosRepo extends FirebaseEntityRepo<Todo> {}
