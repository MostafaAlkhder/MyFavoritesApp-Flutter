import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfavoritespro/bookScreen.dart';
import 'package:myfavoritespro/moviesScreen.dart';
import 'package:myfavoritespro/seriesScreen.dart';
import 'package:myfavoritespro/bloc/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  late Database database;
  List<Widget> screens = [SeriesScreen(), MoviesScreen(), BooksScreen()];
  String typeValue = 'Series';
  List<String> typeList = ['Series', 'Movies', 'Book'];
  bool bottomSheetOpen = false;
  IconData addingButtonIcon = Icons.edit;
  List<Map> Series = [];
  List<Map> Movies = [];
  List<Map> Books = [];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void changingBottomSheetState({required bool isBottomSheetOpen}) {
    bottomSheetOpen = isBottomSheetOpen;
    addingButtonIcon = !isBottomSheetOpen ? Icons.edit : Icons.save;
    emit(AppChangeBottomSheetState());
  }

  void createDatebase() {
    openDatabase(
      'favorites.db',
      version: 1,
      onCreate: (database, version) {
        print("Database created");
        database
            .execute(
                'CREATE TABLE favorites (id INTEGER PRIMARY KEY, title TEXT, type TEXT, date TEXT)')
            .then((value) {
          print("table created");
        }).catchError((error) {
          print("Error when creating table${error.toString()}");
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('Database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatebase(
      {required String title,
      required String type,
      required String date}) async {
    return await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO favorites(title, date, type) VALUES("{$title}", "{$date}", "{$type}")')
          .then((value) {
        emit(AppInsertDatabaseState());
        print("${value} inserted successfully");
        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error When Inserted New Record ${error.toString()}');
      });
      // return null;
    });
  }

  void getDataFromDatabase(database) {
    Series = [];
    Movies = [];
    Books = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM favorites').then((value) {
      value.forEach((element) {
        print(element);
        if (element['type'] == '{Series}') {
          this.Series.add(element);
        } else if (element['type'] == '{Movies}') {
          this.Movies.add(element);
        } else {
          this.Books.add(element);
        }
        ;
      });

      emit(AppGetDatabaseState());
    });
    ;
  }

  void deleteData({
    required int id,
  }) async {
    database
        .rawDelete('DELETE From favorites WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  String stringWithoutBracketes(String title) {
    String newtitle = title.substring(1, title.length - 1);
    return newtitle;
  }
}
