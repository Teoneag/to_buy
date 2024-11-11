import 'package:cloud_firestore/cloud_firestore.dart';

import 'models.dart';

class FireabseMethods {
  static final _tasksRef = FirebaseFirestore.instance.collection('items');

  static Future<void> addItem(Item item) async {
    await _tasksRef.add(item.toJson());
  }

  static Future<void> deleteItem(String name) async {
    final snap = await _tasksRef.where('name', isEqualTo: name).limit(1).get();
    final doc = snap.docs.first;
    await doc.reference.delete();
  }

  static Stream<List<Item>> getItems() {
    return _tasksRef.orderBy('position').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Item.fromJson(doc.data())).toList();
    });
  }
}
