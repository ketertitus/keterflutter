// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:market/aux/extra/user_details.dart';
import 'package:market/aux/screens/fromInventory/edit.dart';

import '../extra/item.dart';
import 'fromInventory/sale.dart';

class Inventory extends StatefulWidget {
  bool isSale = false;
  Inventory({super.key, required bool isSaleInput}) {
    isSale = isSaleInput;
  }
  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  bool? isSaleInv;
  List<Item> selectedItems = [];
  bool renew = false;
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection("salesItems").snapshots();

  @override
  Widget build(BuildContext context) {
    isSaleInv = widget.isSale;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        title: Text(
            widget.isSale ? "Select Items from Inventory..." : "Inventory"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text("Loading..."),
                ),
              ],
            ));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              return Column(
                children: [
                  ListTile(
                    textColor: isSelected(toItem(data))
                        ? Colors.blue
                        : Theme.of(context).textTheme.bodyMedium!.color,
                    onTap: widget.isSale
                        ? () {
                            data["qty"] > 0 ? select(data) : null;
                          }
                        : () => toEdit(data),
                    title: Text(data['name']),
                    subtitle: Text("@KSh ${data['price']}"),
                    leading: Text(data['id']),
                    trailing: isSelected(toItem(data))
                        ? const Icon(
                            Icons.check_circle_outline_outlined,
                            color: Colors.blue,
                          )
                        : Text(
                            data['qty'] == 0
                                ? "Out of Stock"
                                : data['qty'].toString(),
                            style: data['qty'] == 0
                                ? const TextStyle(
                                    fontSize: 12, color: Colors.red)
                                : null,
                          ),
                  ),
                  const Divider(),
                ],
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton:
          widget.isSale ? showSelected(context) : toAddScreen(context),
    );
  }

  Item toItem(Map<String, dynamic> dataMap) => Item(
      id: dataMap["id"],
      name: dataMap["name"],
      qty: dataMap["qty"],
      price: double.parse(dataMap["price"].toString()));

  IconButton toAddScreen(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditItem(inItem: Item(), inIsNew: true))),
      icon: const Icon(
        Icons.add_circle_outline,
        color: Colors.blue,
      ),
    );
  }

  IconButton showSelected(BuildContext context) {
    return IconButton(
      onPressed: () async {
        bool renewal = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Sales(selected: selectedItems)));
        setState(() {
          renew = renewal;
        });
        renew ? selectedItems.clear() : null;
      },
      icon: const Icon(
        Icons.arrow_circle_right_outlined,
        color: Colors.blue,
      ),
    );
  }

  bool isSelected(Item ifSelected) => selectedItems.contains(ifSelected);

  select(Map<String, dynamic> data) {
    Item selected = toItem(data);
    isSelected(selected)
        ? selectedItems.remove(selected)
        : selectedItems.add(selected);
    setState(() {});
  }

  toEdit(Map<String, dynamic> data) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              EditItem(inItem: toItem(data), inIsNew: false)));
}
