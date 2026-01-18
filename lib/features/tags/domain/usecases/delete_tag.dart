import 'package:architecture/core/domain/usecases/delete_entity.dart';
import 'package:architecture/features/tags/domain/entities/tag.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteTag extends DeleteEntity<Tag> {
  DeleteTag({required super.eventBus});
}
