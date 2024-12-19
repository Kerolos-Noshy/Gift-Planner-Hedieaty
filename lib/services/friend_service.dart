import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty/services/user_service.dart';

import '../models/user_model.dart';
import 'firestore_service.dart';

class FriendService {
  final FirestoreService _firestoreService = FirestoreService();
  final _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'friends';

  Future<void> addFriend(String userId, String friendId) async {
    try {
      await _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .doc(friendId)
        .set({});

      await _firestore
          .collection('users')
          .doc(friendId)
          .collection('friends')
          .doc(userId)
          .set({});
      print('Friend added successfully!');
    } catch (e) {
      print('Failed to add friend: $e');
    }
  }

  Future<List<User>> getFriends(String userId) async {
    // List<String> friendIds = [];
    List<User> friends = [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('friends')
          .get();

      for (var doc in snapshot.docs) {
        // friendIds.add(doc.id);
        User? u = await UserService().getUser(doc.id);
        friends.add(u!);
      }
    } catch (e) {
      print('Failed to get friends: $e');
    }

    return friends;
  }

  Future<int> getFriendsCount(String userId) async {

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('friends')
          .get();

      return snapshot.size;
    } catch (e) {
      print('Failed to get friends: $e');
    }

    return 0;
  }

  Future<void> removeFriend(String userId, String friendId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('friends')
          .doc(friendId)
          .delete();
      print('Friend removed successfully!');
    } catch (e) {
      print('Failed to remove friend: $e');
    }
  }

  Future<bool> friendshipExists(String userId, String friendId) async {
    try {
      final friendDoc = await _firestore
          .collection(_collectionPath)
          .doc(userId)
          .collection('friends')
          .doc(friendId)
          .get();

      return friendDoc.exists;
    } catch (e) {
      print('Failed to check friendship: $e');
      return false;
    }
  }
}
