import 'package:architecture/core/presentation/cubits/cubit_observer.dart';
import 'package:architecture/core/service_locator/service_locator.dart';
import 'package:architecture/features/tags/presentation/cubits/tags_cubit.dart';
import 'package:architecture/features/todos/presentation/cubits/todos_cubit.dart';
import 'package:architecture/features/todos/presentation/pages/todos_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  configureDependencies();
  Bloc.observer = CubitObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<TodosCubit>()),
        BlocProvider(create: (context) => getIt<TagsCubit>()),
      ],
      child: MaterialApp(
        title: 'Architecure Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const TodosPage(),
      ),
    );
  }
}
