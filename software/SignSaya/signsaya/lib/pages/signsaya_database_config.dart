import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SignSayaDatabase {
  static final SignSayaDatabase _instance = SignSayaDatabase.internal();

  factory SignSayaDatabase() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  SignSayaDatabase.internal();

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'translations.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE translations (
        id INTEGER PRIMARY KEY,
        date TEXT,
        time TEXT,
        question TEXT,
        response TEXT,
        translated_response TEXT
      )
    ''');
  }

  Future<int> saveTranslation(Map<String, dynamic> translation) async {
  var dbClient = await db;
  return await dbClient.insert('translations', translation);
}


  Future<List<Map<String, dynamic>>> getAllTranslations() async {
  var dbClient = await db;
  return await dbClient.query('translations');
}


  Future<int> deleteTranslation(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'translations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
