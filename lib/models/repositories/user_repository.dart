import '../user_model.dart';
import '../../database/database_helper.dart';

class UserRepository {
  final String tableName = 'Users';
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<bool> doesPhoneNumberExist(String phoneNumber) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      tableName,
      where: 'phone = ?',
      whereArgs: [phoneNumber],
    );
    return result.isNotEmpty;
  }

  Future<void> insertUser(User user) async {
    final db = await _dbHelper.database;
    await db.insert(tableName, user.toMap());
  }

  Future<User?> getUserById(String userId) async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      return null;
    }
  }

  // Future<List<User>> getAllUsers() async {
  //   final db = await _dbHelper.database;
  //   final List<Map<String, dynamic>> maps = await db.query(tableName);
  //   return maps.map((map) => User.fromMap(map)).toList();
  // }
  //
  // Future<int> updateUser(User user) async {
  //   final db = await _dbHelper.database;
  //   return await db.update(tableName, user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  // }
  //
  // Future<int> deleteUser(String id) async {
  //   final db = await _dbHelper.database;
  //   return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  // }
  //
  // Future<User?> getUserByPhone(String phoneNumber) async {
  //   final db = await _dbHelper.database;
  //   final result = await db.query(
  //     tableName,
  //     where: 'phone = ?',
  //     whereArgs: [phoneNumber],
  //     limit: 1,
  //   );
  //     if (result.isNotEmpty) {
  //       return User.fromMap(result.first);
  //     }
  //   return null;
  // }
}
