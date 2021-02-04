import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:salmankeep/models/keep_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;

  DatabaseHelper._instance();

  String keepsTable = 'keep_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDate = 'date';
  String colPriority = 'priority';
  String colStatus = 'status';

  //Keep Tables
  // id | title | date | priority | status
  // 0     ''      ''       ''        0

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'keep_list.db';
    final keepListDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return keepListDb;
  }
  
  void _createDb(Database db, int version) async {
    await db.execute('CREATE TABLE $keepsTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDate TEXT, $colPriority TEXT, $colStatus INTEGER)',
    );
  }

  Future<List<Map<String, dynamic>>> getKeepMapList() async {
    Database db = await this.db;
    final List <Map<String, dynamic>> result = await db.query(keepsTable);
    return result;
  }

  Future<List<Keep>> getKeepList() async {
    final List<Map<String, dynamic>> keepMapList = await getKeepMapList();
    final List<Keep> keepList = [];
    keepMapList.forEach((keepMap) {
      keepList.add(Keep.fromMap(keepMap));
    });
    keepList.sort((keepA, keepB) => keepA.date.compareTo(keepB.date));
    return keepList;
  }

  Future<int> insertKeep(Keep keep) async {
    Database db = await this.db;
    final int result = await db.insert(keepsTable, keep.toMap());
    return result;
  }

  Future<int> updateKeep(Keep keep) async {
    Database db = await this.db;
    final int result = await db.update(
      keepsTable,
      keep.toMap(),
      where: '$colId = ?',
      whereArgs: [keep.id],
    );
    return result;
  }

  Future<int> deleteKeep(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      keepsTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }
}