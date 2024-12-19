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
}
