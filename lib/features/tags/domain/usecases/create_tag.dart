import 'package:architecture/core/domain/usecases/create_entity.dart';
import 'package:architecture/features/tags/domain/entities/tag.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateTag extends CreateEntity<Tag> {
  CreateTag({required super.eventBus});
}
