import '../event_model.dart';
import '../../database/database_helper.dart';

class EventRepository {
  final String tableName = 'Events';
  final DatabaseHelper _dbHelper = DatabaseHelper();

  EventRepository();

  Future<int> addEvent(Event event) async {
    final db = await _dbHelper.database;

    int id = await db.insert(
        tableName,
        event.toMap()
    );
    return id;
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

  Future<List<Event>> getAllEvents() async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> results = await db.query(
      tableName
    );

    return results.map((map) => Event.fromMap(map)).toList();
  }

  // Retrieve all events for a specific user
  Future<List<Event>> getUserEvents(String userId) async {
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

  Future<void> deleteEventWithGifts(int eventId) async {
    final db = await _dbHelper.database;

    try {
      await db.transaction((txn) async {
        await txn.delete(
          'gifts',
          where: 'event_id = ?',
          whereArgs: [eventId],
        );

        await txn.delete(
          'events',
          where: 'id = ?',
          whereArgs: [eventId],
        );
      });

      print('Event and its gifts successfully deleted.');
    } catch (e) {
      print('Error deleting event and its gifts: $e');
      throw Exception('Failed to delete event and its gifts.');
    }
  }
}
