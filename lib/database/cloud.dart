import 'package:cloud_firestore/cloud_firestore.dart';

import '../aux/extra/item.dart';

class Collection {
  final CollectionReference salesItems =
      FirebaseFirestore.instance.collection("salesItems");

  Future addItem(Item item) async {
    await salesItems.doc(item.id).set({
      "id": item.id,
      "name": item.name,
      "qty": item.qty,
      "price": item.price,
    });
  }
}
