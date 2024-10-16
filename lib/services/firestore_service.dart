import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<T>> getData<T>(
      String path, T Function(Map<String, dynamic> data) builder) {
    return _db.collection(path).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => builder(doc.data())).toList());
  }

  Future<void> setData(String path, Map<String, dynamic> data) async {
    return await _db.collection(path).add(data);
  }

  Future<void> deleteData(String path, String id) async {
    return await _db.collection(path).doc(id).delete();
  }
}
