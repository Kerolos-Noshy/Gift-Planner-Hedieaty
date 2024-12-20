import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty/models/event_model.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> addEvent(String userId, Event eventData) async {
    try {
      final docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .add(eventData.toMap());
      return docRef.id;
    } catch (e) {
      print('Failed to add event: $e');
      return null;
    }
  }

  Future<void> updateEvent(String userId, Event eventData) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(eventData.documentId)
          .update(eventData.toMap());
    } catch (e) {
      print('Failed to update event: $e');
      rethrow;
    }
  }

  Future<void> deleteEvent(String userId, Event event) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(event.documentId)
          .delete();
    } catch (e) {
      print('Failed to delete event: $e');
      rethrow;
    }
  }

  Future<List<Event>> fetchUserEvents(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['document_id'] = doc.id;
        return Event.fromMap(data);
      }).toList();
    } catch (e) {
      print('Failed to fetch events: $e');
      return [];
    }
  }

  Future<Event?> getEventById(String userId, String eventId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(eventId).get();
      return Event.fromMap(snapshot.data()!);

    } catch (e) {
      print('Failed to fetch events: $e');
      return null;
    }
  }

  Future<int> getUserEventsCount(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .get();

      return snapshot.size;
    } catch (e) {
      print('Failed to fetch event count: $e');
      rethrow;
    }
  }

  Future<void> deleteEventWithGifts(String userId, String eventId) async {
    try {
      // Get the reference to the database

      // Start a batch operation
      final batch = _firestore.batch();

      // Query and delete all gifts associated with the event
      final giftsQuery = await _firestore
          .collection('gifts')
          .where('eventId', isEqualTo: eventId)
          .where('giftCreatorId', isEqualTo: userId)
          .get();

      for (var doc in giftsQuery.docs) {
        batch.delete(doc.reference);
      }

      final eventDocRef = _firestore.collection('events').doc(eventId);
      batch.delete(eventDocRef);

      // Commit the batch operation
      await batch.commit();
      print('Event and its gifts successfully deleted.');
    } catch (e) {
      print('Error deleting event and its gifts: $e');
      throw Exception('Failed to delete event and its gifts.');
    }
  }

  Future<List<Map<String, dynamic>>> fetchEventsForNext7Days() async {
    try {
      final now = DateTime.now();
      final next7Days = now.add(const Duration(days: 7));

      final eventsRef = FirebaseFirestore.instance.collection('events');

      final querySnapshot = await eventsRef
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(next7Days))
          .get();

      final events = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();

      return events;
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }
}
