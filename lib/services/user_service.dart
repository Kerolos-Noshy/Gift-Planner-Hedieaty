import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty/models/user_model.dart';


class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'users';

  Future<void> addUser(User userData) async {
    try {
      await _firestore.collection(_collectionPath).doc(userData.id).set(userData.toMap());
      print('User added successfully');
    } catch (e) {
      print('Failed to add user: $e');
    }
  }

  // Update user details
  Future<void> updateUser(String userId, User userData) async {
    try {
      await _firestore.collection(_collectionPath).doc(userId).update(userData.toMap());
      print('User updated successfully');
    } catch (e) {
      print('Failed to update user: $e');
    }
  }

  // Fetch user details
  Future<User?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection(_collectionPath).doc(userId).get();
      if (doc.exists) {
        return User.fromMap(doc.data()!);
      }
      print('User not found');
      return null;
    } catch (e) {
      print('Failed to fetch user: $e');
      return null;
    }
  }

  Future<bool> doesPhoneNumberExist(String phoneNumber) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionPath)
          .where('phone', isEqualTo: phoneNumber)
          .get();
      for (var doc in snapshot.docs)
        print(doc.data());

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Failed to check phone number: $e');
      return false;
    }
  }

  Future<User?> getUserByPhone(String phoneNumber) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionPath)
          .where('phone', isEqualTo: phoneNumber)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return User.fromMap(snapshot.docs.first.data());
      }
      print('User with phone number $phoneNumber not found');
      return null;
    } catch (e) {
      print('Failed to get user by phone: $e');
      return null;
    }
  }
}
