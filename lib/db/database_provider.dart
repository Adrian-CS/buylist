import 'package:flutter/material.dart';
import 'package:food/model/food.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  static const String TABLE_FOOD = "food";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_QUANTITY = "quantity";
  static const String COLUMN_SUPER = "supermarket";

  DatabaseProvider._();
  static final DatabaseProvider db4 = DatabaseProvider._();

  Database _database4;

  Future<Database> get database4 async {
    print("database getter called");

    if (_database4 != null) {
      return _database4;
    }

    _database4 = await createDatabase();

    return _database4;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'foodDB.db4'),
      version: 1,
      onCreate: (Database database4, int version) async {
        print("Creating food table");

        await database4.execute(
          "CREATE TABLE $TABLE_FOOD ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_NAME TEXT,"
          "$COLUMN_QUANTITY TEXT,"
          "$COLUMN_SUPER TEXT"
          ")",
        );
      },
    );
  }

  Future<List<Food>> getFoods() async {
    final db4 = await database4;

    var foods = await db4.query(TABLE_FOOD,
        columns: [COLUMN_ID, COLUMN_NAME, COLUMN_QUANTITY, COLUMN_SUPER]);

    List<Food> foodList = List<Food>();

    foods.forEach((currentFood) {
      Food food = Food.fromMap(currentFood);

      foodList.add(food);
    });

    return foodList;
  }

  Future<Food> insert(Food food) async {
    final db4 = await database4;
    food.id = await db4.insert(TABLE_FOOD, food.toMap());
    return food;
  }

  Future<int> delete(int id) async {
    final db4 = await database4;

    return await db4.delete(
      TABLE_FOOD,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Food food) async {
    final db4 = await database4;

    return await db4.update(
      TABLE_FOOD,
      food.toMap(),
      where: "id = ?",
      whereArgs: [food.id],
    );
  }
}
