import '../event_model.dart';
import '../../database/database_helper.dart';

class EventRepository {
  final String tableName = 'Events';
  final DatabaseHelper _dbHelper = DatabaseHelper();

  EventRepository();

  // Insert a new event
  Future<int> addEvent(Event event) async {
    final db = await _dbHelper.database;
    return await db.insert(tableName, event.toMap());
  }

  // Retrieve an event by ID
  Future<Event?> getEventById(int id) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Event.fromMap(result.first);
    } else {
      return null;
    }
  }

  // Retrieve all events for a specific user
  Future<List<Event>> getEventsByUserId(String userId) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> results = await db.query(
      tableName,
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return results.map((map) => Event.fromMap(map)).toList();
  }

  Future<int> getEventsCountByUserId(String userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
        '''
        SELECT COUNT(*) as eventCount
        FROM $tableName
        WHERE user_id = ?
      ''',[userId]
    );
    if (result.isNotEmpty) {
      return result.first['eventCount'] as int;
    }
    return 0;
  }

  // Update an existing event
  Future<int> updateEvent(Event event) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableName,
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  // Delete an event by ID
  Future<int> deleteEvent(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
