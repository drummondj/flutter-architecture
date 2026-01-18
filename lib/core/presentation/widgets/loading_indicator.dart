import 'package:flutter/material.dart';

enum LoadingIndicatorSize { small, large }

class LoadingIndicator extends StatelessWidget {
  final LoadingIndicatorSize size;
  final double largeSize;
  final double smallSize;

  const LoadingIndicator({
    super.key,
    this.size = LoadingIndicatorSize.large,
    this.largeSize = 50,
    this.smallSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    double indicatorSize = size == LoadingIndicatorSize.small
        ? smallSize
        : largeSize;
    return SizedBox(
      width: indicatorSize,
      height: indicatorSize,
      child: CircularProgressIndicator(),
    );
  }
}
