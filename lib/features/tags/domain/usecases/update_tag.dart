import 'package:architecture/core/domain/usecases/update_entity.dart';
import 'package:architecture/features/tags/domain/entities/tag.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateTag extends UpdateEntity<Tag> {
  UpdateTag({required super.eventBus});
}
