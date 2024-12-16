import 'package:hedieaty/models/gift_model.dart';

import 'firestore_service.dart';

class GiftService {
  final FirestoreService _firestoreService = FirestoreService();
  final String _collectionPath = 'gifts';

  Future<void> addGift(Gift giftData) async {
    await _firestoreService.addDocument(_collectionPath, giftData.toMap());
  }

  Future<void> updateGift(String id, Gift giftData) async {
    await _firestoreService.updateDocument(_collectionPath, id, giftData.toMap());
  }

  Future<void> deleteGift(String id) async {
    await _firestoreService.deleteDocument(_collectionPath, id);
  }

  Future<List<Map<String, dynamic>>> fetchGifts() async {
    return await _firestoreService.fetchCollection(_collectionPath);
  }
}
