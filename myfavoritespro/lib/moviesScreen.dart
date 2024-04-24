import 'package:animated_conditional_builder/animated_conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfavoritespro/bloc/cubit.dart';
import 'package:myfavoritespro/bloc/states.dart';

class MoviesScreen extends StatelessWidget {
  const MoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
      if (state is AppGetDatabaseLoadingState) {}
    }, builder: (context, state) {
      var Movies = AppCubit.get(context).Movies;
      return AnimatedConditionalBuilder(
          condition: Movies.length > 0,
          fallback: (context) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu,
                      color: Colors.grey,
                      size: 100.0,
                    ),
                    Text(
                      "No Tasks Yey , Please Add Some Movies",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
          builder: (context) {
            return ListView.separated(
              itemBuilder: (context, index) => Dismissible(
                key: Key(Movies[index]["id"].toString()),
                onDismissed: (direction) {
                  AppCubit.get(context).deleteData(id: Movies[index]["id"]);
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    // children: [Text(Movies[index]['title'])],
                    children: [
                      Text(
                        "${AppCubit.get(context).stringWithoutBracketes(Movies[index]['title'])}",
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${AppCubit.get(context).stringWithoutBracketes(Movies[index]['date'])}",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              separatorBuilder: (BuildContext context, int index) => Container(
                  width: double.infinity, height: 1.0, color: Colors.grey[300]),
              itemCount: Movies.length,
            );
          });
    });
  }
}
