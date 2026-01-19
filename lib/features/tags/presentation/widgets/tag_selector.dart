import 'package:architecture/core/presentation/cubits/entity_state.dart';
import 'package:architecture/core/presentation/widgets/error_message.dart';
import 'package:architecture/core/presentation/widgets/loading_indicator.dart';
import 'package:architecture/features/tags/domain/entities/tag.dart';
import 'package:architecture/features/tags/presentation/cubits/tags_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class TagSelector extends StatefulWidget {
  final List<String> initialTagIds;
  const TagSelector({super.key, required this.initialTagIds});

  @override
  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  @override
  void initState() {
    super.initState();
    context.read<TagsCubit>().loadAllTags();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagsCubit, EntityState<Tag>>(
      builder: (context, state) {
        switch (state) {
          case EntityInitialState<Tag>() || EntityLoadingState<Tag>():
            return Center(
              child: LoadingIndicator(size: LoadingIndicatorSize.small),
            );
          case EntityLoadedState<Tag>():
            return FormBuilderCheckboxGroup<String>(
              name: "tagIds",
              initialValue: widget.initialTagIds,
              options: context
                  .read<TagsCubit>()
                  .getAllTags()
                  .map(
                    (tag) => FormBuilderFieldOption<String>(
                      value: tag.uid!,
                      child: Text(tag.name),
                    ),
                  )
                  .toList(),
            );
          case EntityErrorState<Tag>():
            return Center(child: ErrorMessage(message: "Unable to load tags"));
        }
      },
    );
  }
}
