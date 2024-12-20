import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/gift_model.dart';


class GiftService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String?> addGift(String userId, String eventId, Gift gift) async {
    try {
      final docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(eventId)
          .collection('gifts')
          .add(gift.toMap());
      return docRef.id;
    } catch (e) {
      print('Failed to add gift: $e');
      rethrow;
    }
  }

  static Future<void> updateGift(String userId, String eventId, Gift gift) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(eventId)
          .collection('gifts')
          .doc(gift.documentId)
          .update(gift.toMap());
    } catch (e) {
      print('Failed to update gift: $e');
      rethrow;
    }
  }

  static Future<void> deleteGift(String userId, String eventId, String giftId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(eventId)
          .collection('gifts')
          .doc(giftId)
          .delete();
    } catch (e) {
      print('Failed to delete gift: $e');
      rethrow;
    }
  }

  static Future<List<Gift>> fetchEventGifts(String userId, String eventId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(eventId)
          .collection('gifts')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['document_id'] = doc.id;
        return Gift.fromMap(data);
      }).toList();
    } catch (e) {
      print('Failed to fetch gifts: $e');
      return [];
    }
  }

  static Future<int> getGiftCount(String userId, String eventId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(eventId)
          .collection('gifts')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Failed to get gift count: $e');
      return 0;
    }
  }

  static Future<int> countPledgedGifts(String userId, String eventId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(eventId)
          .collection('gifts')
          .where('pledger_id', isNotEqualTo: null)
          .get();

      return snapshot.size;
    } catch (e) {
      print('Failed to count pledged gifts: $e');
      rethrow;
    }
  }

  static Future<int> countUnPledgedGifts(String userId, String eventId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(eventId)
          .collection('gifts')
          .where('pledger_id', isEqualTo: null)
          .get();

      return snapshot.size;
    } catch (e) {
      print('Failed to count pledged gifts: $e');
      rethrow;
    }
  }

  static Future<void> deleteAllGifts(String userId, String eventId) async {
    try {
      // Reference to the gifts collection
      final giftsCollection = _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(eventId)
          .collection('gifts');

      final snapshot = await giftsCollection.get();

      WriteBatch batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print('All gifts for event $eventId have been deleted successfully.');
    } catch (e) {
      print('Failed to delete gifts: $e');
      rethrow;
    }
  }

  static Future<List<Gift>> getPledgedGifts(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup('gifts')
          .where('pledger_id', isEqualTo: userId)
          .orderBy('document_id')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Gift.fromMap(data)..documentId = doc.id;
      }).toList();
    } catch (e) {
      print('Failed to fetch pledged gifts: $e');
      rethrow;
    }
  }
}