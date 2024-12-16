import 'package:hedieaty/models/user_model.dart';

import 'firestore_service.dart';

class UserService {
  final FirestoreService _firestoreService = FirestoreService();
  final String _collectionPath = 'users';

  Future<void> addUser(User userData) async {
    await _firestoreService.addDocument(_collectionPath, userData.toMap());
  }

  Future<void> updateUser(String id, User userData) async {
    await _firestoreService.updateDocument(_collectionPath, id, userData.toMap());
  }

  Future<void> deleteUser(String id) async {
    await _firestoreService.deleteDocument(_collectionPath, id);
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    return await _firestoreService.fetchCollection(_collectionPath);
  }
}
