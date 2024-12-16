import 'package:hedieaty/models/friend_model.dart';

import 'firestore_service.dart';

class FriendService {
  final FirestoreService _firestoreService = FirestoreService();
  final String _collectionPath = 'friends';

  Future<void> addFriend(Friend friendData) async {
    await _firestoreService.addDocument(_collectionPath, friendData.toMap());
  }

  Future<void> deleteFriend(int userId, int friendId) async {
    final querySnapshot = await _firestoreService.fetchCollection(_collectionPath);
    for (var doc in querySnapshot) {
      if (doc['user_id'] == userId && doc['friend_id'] == friendId) {
        await _firestoreService.deleteDocument(_collectionPath, doc['id']);
        break;
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchFriends(int userId) async {
    final querySnapshot = await _firestoreService.fetchCollection(_collectionPath);
    return querySnapshot.where((doc) => doc['user_id'] == userId).toList();
  }
}
