import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CubitObserver extends BlocObserver {
  CubitObserver();

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint("CubitObserver ERROR: ${bloc.runtimeType} ${error.toString()}");
    super.onError(bloc, error, stackTrace);
  }
}
