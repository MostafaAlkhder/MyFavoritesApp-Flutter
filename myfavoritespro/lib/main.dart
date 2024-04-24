import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:myfavoritespro/bloc/bloc_observer.dart';
import 'package:myfavoritespro/layout.dart';
import 'package:myfavoritespro/seriesScreen.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Scaffold(
          body: Layout(),
        ));
  }
}
