import 'package:architecture/core/domain/entities/entity_with_id_and_timestamps.dart';
import 'package:architecture/core/exceptions/app_exception.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'entity_state.g.dart';

enum EntityStateStatus { initial, loading, loaded, updating, updated, error }

sealed class EntityState<T extends EntityWithIdAndTimestamps>
    extends Equatable {
  final EntityStateStatus status;
  final String? message;

  const EntityState({required this.status, this.message});

  @override
  List<Object?> get props => [status, message];

  @override
  String toString() {
    return "$runtimeType: status = ${status.name}";
  }
}

class EntityInitialState<T extends EntityWithIdAndTimestamps>
    extends EntityState<T> {
  const EntityInitialState({required super.status, super.message});
}

class EntityLoadingState<T extends EntityWithIdAndTimestamps>
    extends EntityState<T> {
  const EntityLoadingState({required super.status, super.message});
}

@CopyWith()
class EntityLoadedState<T extends EntityWithIdAndTimestamps>
    extends EntityState<T> {
  final List<T> entities;

  const EntityLoadedState({
    required this.entities,
    required super.status,
    super.message,
  });

  @override
  List<Object?> get props => [...super.props, entities];
}

class EntityErrorState<T extends EntityWithIdAndTimestamps>
    extends EntityState<T> {
  final AppException error;
  const EntityErrorState({
    required super.status,
    super.message,
    required this.error,
  });
}
