import 'package:architecture/core/domain/entities/entity_with_id_and_timestamps.dart';
import 'package:architecture/core/presentation/cubits/entity_state.dart';
import 'package:flutter/material.dart';

extension EntityStateSnackbar on BuildContext {
  void showEntityMessage<T extends EntityWithIdAndTimestamps>(
    EntityState<T> state,
  ) {
    if (state.message != null) {
      bool isError =
          (state is EntityLoadedState<T> &&
          state.status == EntityStateStatus.error);
      ScaffoldMessenger.of(this).removeCurrentSnackBar();
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          backgroundColor: isError ? Theme.of(this).colorScheme.error : null,
          content: Center(child: Text(state.message!)),
        ),
      );
    }
  }
}
