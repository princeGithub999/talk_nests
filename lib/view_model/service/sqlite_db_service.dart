import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../model/sqlite_db_model/sqlite_user_model.dart';

class SqliteDbService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final getDirectory = await getApplicationDocumentsDirectory();
    String path = '${getDirectory.path}/user.db';
    // log(path);
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE IF NOT EXISTS USER(roomId TEXT PRIMARY KEY, userName TEXT, senderId TEXT, timestamp TEXT, receiverId TEXT, userImageUrl STRING, onLineStatus TEXT, senderName TEXT)',
    );
    log('USER TABLE CREATED');
  }

  Future<void> insertUser(SqliteUserModel user) async {
    final db = await database;
    try {
      var data = await db.rawInsert(
        'INSERT INTO USER(roomId, userName, senderId, timestamp, receiverId, userImageUrl, onLineStatus, senderName) VALUES(?, ?, ?, ?, ?, ?, ?, ?)',
        [
          user.roomId,
          user.userName,
          user.senderId,
          user.timestamp,
          user.receiverId,
          user.userImageUrl,
          user.onLineStatus,
          user.senderName
        ],
      );
      Fluttertoast.showToast(msg: 'sq save data');
      log('User inserted with ID: $data');
    } catch (e) {
      log('Error during insert: $e');
    }
  }

  // Fetch all user data
  Future<List<SqliteUserModel>> getUserData() async {
    final db = await database;
    try {
      var data = await db.rawQuery('SELECT * FROM USER');
      List<SqliteUserModel> users = List.generate(
        data.length,
        (index) => SqliteUserModel.fromMap(data[index]),
      );

      log('Retrieved ${users.length} users');
      return users;
    } catch (e) {
      log('Error during fetch: $e');
      return [];
    }
  }

  // Update user details
  Future<void> updateUserData(SqliteUserModel user) async {
    final db = await database;
    try {
      var data = await db.rawUpdate(
        'UPDATE USER SET name=?, email=?, image=? WHERE id=?',
        [
          // user.name, user.email, user.image, user.id
        ],
      );
      log('User updated with ID: $data');
      await getUserData();
    } catch (e) {
      log('Error during update: $e');
    }
  }

  // Delete user data
  Future<void> deleteUserData(String id) async {
    final db = await database;
    try {
      var data = await db.rawDelete('DELETE FROM USER WHERE id=?', [id]);
      log('User deleted with ID: $data');
    } catch (e) {
      log('Error during delete: $e');
    }
  }
}
