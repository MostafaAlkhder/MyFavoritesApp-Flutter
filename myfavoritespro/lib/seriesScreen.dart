import 'package:animated_conditional_builder/animated_conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfavoritespro/bloc/cubit.dart';
import 'package:myfavoritespro/bloc/states.dart';

class SeriesScreen extends StatelessWidget {
  const SeriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
      if (state is AppGetDatabaseLoadingState) {}
    }, builder: (context, state) {
      var Series = AppCubit.get(context).Series;
      return AnimatedConditionalBuilder(
          condition: Series.length > 0,
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
                      "No Tasks Yey , Please Add Some Series",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
          builder: (context) {
            return ListView.separated(
              itemBuilder: (context, index) => Dismissible(
                key: Key(Series[index]["id"].toString()),
                onDismissed: (direction) {
                  AppCubit.get(context).deleteData(id: Series[index]["id"]);
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    // children: [Text(Series[index]['title'])],
                    children: [
                      Text(
                        "${AppCubit.get(context).stringWithoutBracketes(Series[index]['title'])}",
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${AppCubit.get(context).stringWithoutBracketes(Series[index]['date'])}",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              separatorBuilder: (BuildContext context, int index) => Container(
                  width: double.infinity, height: 1.0, color: Colors.grey[300]),
              itemCount: Series.length,
            );
          });
    });
  }
}







        // return BlocConsumer(
        //   listener: (context, state) {
        //     if (state is AppGetDatabaseLoadingState) {}
        //   },
        //   builder: (context, state) {
        //     var Series = AppCubit.get(context).Series;

        // return AnimatedConditionalBuilder(
        //     condition: false,
        //     fallback: (context) => Center(
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Icon(
        //                 Icons.menu,
        //                 color: Colors.grey,
        //                 size: 100.0,
        //               ),
        //               Text(
        //                 "No Tasks Yey , Please Add Some Series",
        //                 style: TextStyle(
        //                     fontSize: 20.0, fontWeight: FontWeight.bold),
        //               )
        //             ],
        //           ),
        //         ),
        //     builder: (context) => Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Icon(
        //               Icons.menu,
        //               color: Colors.grey,
        //               size: 100.0,
        //             ),
        //             Text(
        //               "No Tasks Yey , Please Add Some Series",
        //               style: TextStyle(
        //                   fontSize: 20.0, fontWeight: FontWeight.bold),
        //             )
        //           ],
        //         )
        // ListView.separated(
        //     itemBuilder: (context, index) => Dismissible(
        //           key: Key(Series[index]["id"].toString()),
        //           onDismissed: (direction) {
        //             cubit.deleteData(id: Series[index]["id"]);
        //           },
        //           child: Text(""),
        //         ),
        //     separatorBuilder: (context, index) => Container(
        //         width: double.infinity, height: 1.0, color: Colors.grey[300]),
        //     itemCount: Series.length),
        // );
        // },
//       ),
//     );
//   }
// }
