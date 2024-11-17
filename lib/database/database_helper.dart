import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton pattern for database helper
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Database initialization
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'gifts_app.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
    );
  }

  // SQL for creating tables
  Future _onCreate(Database db, int version) async {
    await db.execute('DROP TABLE IF EXISTS Users');
    await db.execute('''
      CREATE TABLE Users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        preferences TEXT,
        gender TEXT NOT NULL,
        profile_image_path TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE Events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        date TEXT,
        location TEXT,
        description TEXT,
        user_id INTEGER,
        FOREIGN KEY (user_id) REFERENCES Users(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE Gifts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT,
        price REAL,
        status TEXT,
        event_id INTEGER,
        FOREIGN KEY (event_id) REFERENCES Events(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE Friends (
        user_id INTEGER,
        friend_id INTEGER,
        PRIMARY KEY (user_id, friend_id),
        FOREIGN KEY (user_id) REFERENCES Users(id),
        FOREIGN KEY (friend_id) REFERENCES Users(id)
      );
    ''');
  }
}
