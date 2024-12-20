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
      version: 9,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('DROP TABLE IF EXISTS Users');
    await db.execute('DROP TABLE IF EXISTS Events');
    await db.execute('DROP TABLE IF EXISTS Gifts');
    await db.execute('DROP TABLE IF EXISTS Friends');
    await db.execute('''
      CREATE TABLE Users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT NOT NULL,
        preferences TEXT,
        gender TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE Events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        document_id TEXT,
        name TEXT NOT NULL,
        date TEXT,
        location TEXT,
        description TEXT,
        user_id TEXT,
        event_type Text,
        is_public INTEGER,
        FOREIGN KEY (user_id) REFERENCES Users(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE Gifts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        document_id TEXT,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT,
        price DOUBLE,
        status TEXT,
        event_id INTEGER,
        event_doc_id TEXT,
        gift_creator_id TEXT,
        pledger_id TEXT,
        FOREIGN KEY (event_id) REFERENCES Events(id),
        FOREIGN KEY (pledger_id) REFERENCES Users(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE Friends (
        user_id TEXT,
        friend_id TEXT,
        PRIMARY KEY (user_id, friend_id),
        FOREIGN KEY (user_id) REFERENCES Users(id),
        FOREIGN KEY (friend_id) REFERENCES Users(id)
      );
    ''');
  }

  Future<void> resetDatabase() async {
    final db = await database;
    // await db.execute('DROP TABLE IF EXISTS Users');
    await db.execute('DROP TABLE IF EXISTS Events');
    await db.execute('DROP TABLE IF EXISTS Gifts');
    // await db.execute('DROP TABLE IF EXISTS Friends');

    // await db.execute('''
    //   CREATE TABLE Users (
    //     id TEXT PRIMARY KEY,
    //     name TEXT NOT NULL,
    //     phone TEXT NOT NULL,
    //     email TEXT NOT NULL,
    //     preferences TEXT,
    //     gender TEXT NOT NULL
    //   );
    // ''');

    await db.execute('''
      CREATE TABLE Events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        document_id TEXT,
        name TEXT NOT NULL,
        date TEXT,
        location TEXT,
        description TEXT,
        user_id TEXT,
        event_type Text,
        is_public INTEGER,
        FOREIGN KEY (user_id) REFERENCES Users(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE Gifts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        document_id TEXT,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT,
        price DOUBLE,
        status TEXT,
        event_id INTEGER,
        event_doc_id TEXT,
        gift_creator_id TEXT,
        pledger_id TEXT,
        FOREIGN KEY (event_id) REFERENCES Events(id),
        FOREIGN KEY (pledger_id) REFERENCES Users(id)
      );
    ''');
    //
    // await db.execute('''
    //   CREATE TABLE Friends (
    //     user_id TEXT,
    //     friend_id TEXT,
    //     PRIMARY KEY (user_id, friend_id),
    //     FOREIGN KEY (user_id) REFERENCES Users(id),
    //     FOREIGN KEY (friend_id) REFERENCES Users(id)
    //   );
    // ''');
  }
}
