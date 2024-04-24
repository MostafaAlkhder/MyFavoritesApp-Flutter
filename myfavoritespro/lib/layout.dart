import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:myfavoritespro/bloc/cubit.dart';
import 'package:myfavoritespro/bloc/states.dart';

IconData suffixIcon = Icons.add;
var scaffoldKey = GlobalKey<ScaffoldState>();
var newFormKey = GlobalKey<FormState>();
var titleController = TextEditingController();
var typeController = TextEditingController();
var dateController = TextEditingController();

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatebase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            body: cubit.screens[cubit.currentIndex],
            appBar: AppBar(title: Text("My Favorites")),
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.addingButtonIcon),
              onPressed: () {
                if (!cubit.bottomSheetOpen) {
                  cubit.changingBottomSheetState(isBottomSheetOpen: true);
                  scaffoldKey.currentState
                      ?.showBottomSheet((context) => Container(
                          color: Colors.grey[100],
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                              key: newFormKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: titleController,
                                    keyboardType: TextInputType.text,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please add the title';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Task Title',
                                      labelStyle: TextStyle(
                                          color: Colors.black87, fontSize: 18),
                                      prefixIcon: Icon(Icons.title),
                                      suffixIcon: suffixIcon != null
                                          ? null
                                          : IconButton(
                                              onPressed: () {},
                                              icon: Icon(suffixIcon)),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    value: cubit.typeValue,
                                    isExpanded: true,
                                    icon: Icon(Icons.arrow_drop_down),
                                    style: TextStyle(
                                        color: Colors.black87, fontSize: 18),
                                    items: cubit.typeList.map((String type) {
                                      return new DropdownMenuItem(
                                          value: type, child: Text(type));
                                    }).toList(),
                                    onChanged: (value) {
                                      cubit.typeValue = value!;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: dateController,
                                    keyboardType: TextInputType.datetime,
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate:
                                                  DateTime.parse('1970-09-29'),
                                              lastDate:
                                                  DateTime.parse('2050-09-29'))
                                          .then((value) {
                                        if (value != null)
                                          dateController.text =
                                              DateFormat.yMMMd().format(value);
                                      });
                                    },
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please add the title';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Date',
                                      labelStyle: TextStyle(
                                          color: Colors.black87, fontSize: 18),
                                      prefixIcon: Icon(Icons.title),
                                      suffixIcon: suffixIcon != null
                                          ? null
                                          : IconButton(
                                              onPressed: () {},
                                              icon: Icon(suffixIcon)),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ))))
                      .closed
                      .then((closed) {
                    // if (newFormKey.currentState!.validate()) {
                    //   cubit.insertToDatebase(
                    //       title: titleController.text,
                    //       date: dateController.text,
                    //       type: cubit.typeValue);
                    // }
                    cubit.changingBottomSheetState(isBottomSheetOpen: false);
                    // titleController.text = "";
                    // dateController.text = "";
                    // cubit.typeValue = "";
                  });
                } else {
                  if (newFormKey.currentState!.validate()) {
                    cubit.insertToDatebase(
                        title: titleController.text,
                        date: dateController.text,
                        type: cubit.typeValue);
                  }
                  cubit.changingBottomSheetState(isBottomSheetOpen: false);
                  // titleController.text = "";
                  // dateController.text = "";
                  // cubit.typeValue = "";
                  // Navigator.pop(context);
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.tv), label: "Series"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.movie), label: "Movies"),
                BottomNavigationBarItem(icon: Icon(Icons.book), label: "Books"),
              ],
              elevation: 20.0,
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
            ),
          );
        },
      ),
    );
  }
}
