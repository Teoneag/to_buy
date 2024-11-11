import 'package:cloud_firestore/cloud_firestore.dart';

const String itemsS = 'items';

class FireabseMethods {
  static final _itemsRef =
      FirebaseFirestore.instance.collection(itemsS).doc(itemsS);

  static Future<void> addItem(String item) async {
    // if collection doesn't exist, create it
    if (!(await _itemsRef.get()).exists) {
      await _itemsRef.set({itemsS: []});
    }
    await _itemsRef.update({
      itemsS: FieldValue.arrayUnion([item]),
    });
  }

  static Future<void> updateItems(List<String> items) async {
    await _itemsRef.set({itemsS: items});
  }

  static Future<void> deleteItem(String name) async {
    await _itemsRef.update({
      itemsS: FieldValue.arrayRemove([name]),
    });
  }

  static Stream<List<String>> getItems() {
    return _itemsRef.snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) return [];
      return List<String>.from(data[itemsS]);
    });
  }
}
