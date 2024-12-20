import '../gift_model.dart';
import '../../database/database_helper.dart';

class GiftRepository {
  final String tableName = 'Gifts';
  final DatabaseHelper _dbHelper = DatabaseHelper();

  GiftRepository();

  Future<int> addGift(Gift gift) async {
    final db = await _dbHelper.database;

    int id = await db.insert(
      tableName,
      gift.toMap()
    );
    return id;
  }

  Future<Gift?> getGiftById(String documentId) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'document_id = ?',
      whereArgs: [documentId],
    );

    if (result.isNotEmpty) {
      return Gift.fromMap(result.first);
    } else {
      return null;
    }
  }

  // Retrieve all gifts for a specific event
  Future<List<Gift>> getGiftsByEventId(int eventId) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> results = await db.query(
      tableName,
      where: 'event_id = ?',
      whereArgs: [eventId],
    );

    return results.map((map) => Gift.fromMap(map)).toList();
  }

  // Count gifts for a specific event
  Future<int> getGiftsCountByEventId(int eventId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
        '''
        SELECT COUNT(*) as giftCount
        FROM $tableName
        WHERE event_id = ?
      ''',
        [eventId]);
    if (result.isNotEmpty) {
      return result.first['giftCount'] as int;
    }
    return 0;
  }

  // Update an existing gift
  Future<int> updateGift(Gift gift) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableName,
      gift.toMap(),
      where: 'document_id = ?',
      whereArgs: [gift.documentId],
    );
  }

  // Delete a gift by ID
  Future<int> deleteGift(String documentId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableName,
      where: 'document_id = ?',
      whereArgs: [documentId],
    );
  }
}
