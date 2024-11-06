import 'package:cloud_firestore/cloud_firestore.dart';

class FireabseMethods {
  static final _tasksRef = FirebaseFirestore.instance.collection('tasks');

  static Future<void> addTask(String task) async {
    await _tasksRef.add(<String, dynamic>{
      'task': task,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> deleteTask(String task) async {
    final snapshot =
        await _tasksRef.where('task', isEqualTo: task).limit(1).get();
    final doc = snapshot.docs.first;
    await doc.reference.delete();
  }

  static Stream<List<String>> getTasks() {
    return _tasksRef
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc['task'] as String).toList();
    });
  }
}
