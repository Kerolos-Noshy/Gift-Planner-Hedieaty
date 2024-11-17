import '../friend_model.dart';
import '../../database/database_helper.dart';
import '../user_model.dart';

class FriendRepository {
  final String tableName = 'Friends';
  final DatabaseHelper _dbHelper = DatabaseHelper();

  FriendRepository();

  // Add a new friend relationship
  Future<int> addFriend(Friend friend) async {
    final db = await _dbHelper.database;
    return await db.insert(tableName, friend.toMap());
  }

  // Remove a friend relationship
  Future<int> removeFriend(int userId, int friendId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableName,
      where: 'user_id = ? AND friend_id = ?',
      whereArgs: [userId, friendId],
    );
  }

  // Check if a friendship exists
  Future<bool> friendshipExists(int userId, int friendId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'user_id = ? AND friend_id = ?',
      whereArgs: [userId, friendId],
    );
    return result.isNotEmpty;
  }

  // Get all friends for a specific user
  // Future<List<Friend>> getFriends(int userId) async {
  //   final db = await _dbHelper.database;
  //   final List<Map<String, dynamic>> results = await db.query(
  //     tableName,
  //     where: 'user_id = ?',
  //     whereArgs: [userId],
  //   );
  //
  //   return results.map((map) => Friend.fromMap(map)).toList();
  // }

  // Future<List<Map<String, dynamic>>> getFriends(int userId) async {
  //   final db = await _dbHelper.database;
  //
  //   // Perform a JOIN to get the friend's name from the Users table
  //   final List<Map<String, dynamic>> results = await db.rawQuery('''
  //     SELECT f.user_id, f.friend_id, u.name AS friend_name
  //     FROM Friends f
  //     INNER JOIN Users u ON f.friend_id = u.id
  //     WHERE f.user_id = ?
  //   ''', [userId]);
  //
  //   return results;
  // }

  Future<List<User>> getFriends(int userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT u.* 
      FROM Friends f
      JOIN Users u ON f.friend_id = u.id
      WHERE f.user_id = ?
    ''', [userId]);

    return results.map((map) => User.fromMap(map)).toList();
  }

  // Get all users who have added the given user as a friend
  Future<List<Friend>> getFriendsOf(int friendId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> results = await db.query(
      tableName,
      where: 'friend_id = ?',
      whereArgs: [friendId],
    );

    return results.map((map) => Friend.fromMap(map)).toList();
  }


}
