import 'package:hedieaty/models/event_model.dart';

import 'firestore_service.dart';

class EventService {
  final FirestoreService _firestoreService = FirestoreService();
  final String _collectionPath = 'events';

  Future<void> addEvent(Event eventData) async {
    await _firestoreService.addDocument(_collectionPath, eventData.toMap());
  }

  Future<void> updateEvent(String id, Event eventData) async {
    await _firestoreService.updateDocument(_collectionPath, id, eventData.toMap());
  }

  Future<void> deleteEvent(String id) async {
    await _firestoreService.deleteDocument(_collectionPath, id);
  }

  Future<List<Map<String, dynamic>>> fetchEvents() async {
    return await _firestoreService.fetchCollection(_collectionPath);
  }
}
