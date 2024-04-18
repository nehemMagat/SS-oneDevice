// Importing necessary libraries
import 'dart:async'; // Importing async library for asynchronous operations
import 'package:sqflite/sqflite.dart'; // Importing sqflite library for SQLite database operations
import 'package:path/path.dart'; // Importing path library for path manipulation

class SignSayaDatabase {
  // Class for SQLite database operations
  static final SignSayaDatabase _instance =
      SignSayaDatabase.internal(); // Singleton instance of SignSayaDatabase

  factory SignSayaDatabase() =>
      _instance; // Factory constructor to return the singleton instance

  static Database? _db; // Database instance variable

  // Getter for accessing the database instance asynchronously
  Future<Database> get db async {
    if (_db != null) {
      // If database instance is already initialized, return it
      return _db!;
    }
    _db = await initDb(); // Otherwise, initialize the database
    return _db!;
  }

  SignSayaDatabase.internal(); // Private constructor for internal use only

  // Method to initialize the database
  Future<Database> initDb() async {
    String databasesPath =
        await getDatabasesPath(); // Get the path to the databases directory
    String path = join(databasesPath,
        'translations.db'); // Join the databases path with the database file name
    var db = await openDatabase(path,
        version: 1,
        onCreate:
            _onCreate); // Open the database with the specified path and version
    return db; // Return the initialized database
  }

  // Method to create the database tables
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
    '''); // Execute SQL statement to create the 'translations' table with specified columns
  }

  // Method to save a translation to the database
  Future<int> saveTranslation(Map<String, dynamic> translation) async {
    var dbClient = await db; // Get the database instance
    return await dbClient.insert('translations',
        translation); // Insert the translation into the 'translations' table
  }

  // Method to retrieve all translations from the database
  Future<List<Map<String, dynamic>>> getAllTranslations() async {
    var dbClient = await db; // Get the database instance
    return await dbClient.query(
        'translations'); // Query the 'translations' table to retrieve all translations
  }

  // Method to delete a translation from the database
  Future<int> deleteTranslation(int id) async {
    var dbClient = await db; // Get the database instance
    return await dbClient.delete(
      'translations',
      where: 'id = ?', // Specify the condition for deletion
      whereArgs: [id], // Specify the arguments for the condition
    );
  }
}
