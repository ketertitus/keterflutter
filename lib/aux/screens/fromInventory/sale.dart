import 'package:flutter/material.dart';

import '../../../database/cloud.dart';
import '../../extra/item.dart';

// ignore: must_be_immutable
class Sales extends StatefulWidget {
  List<Item> selectedItems = [];
  Sales({super.key, required List<Item> selected}) {
    selectedItems = selected;
  }

  @override
  // ignore: no_logic_in_create_state
  State<Sales> createState() => _SalesState(inViewedItems: selectedItems);
}

class _SalesState extends State<Sales> {
  bool finalized = false;
  bool toFinalize = false;
  List<Item> viewedItems = [];
  _SalesState({required List<Item> inViewedItems}) {
    viewedItems = inViewedItems;
  }
  double grandTotal = 0;
  @override
  void initState() {
    for (int i = 0; i < viewedItems.length; i++) {
      viewedItems[i].findTotal();
    }
    total();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          finalized
              ? const Text("")
              : TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text("Edit List"))
        ],
        automaticallyImplyLeading: false,
        title: Text(finalized ? "Check out list" : "Selected Items..."),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total amount: Ksh ${totalString()}",
                    style: const TextStyle(fontSize: 20)),
                toFinalize
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          CircularProgressIndicator(),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text("Processing..."),
                          ),
                        ],
                      )
                    : const Text(""),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: SizedBox(
              child: ListView.builder(
                  itemCount: viewedItems.length,
                  itemBuilder: (context, int index) {
                    final TextEditingController controllerQty =
                        TextEditingController();
                    return Column(
                      children: [
                        ListTile(
                          leading: Text(viewedItems[index].id),
                          title: Text(viewedItems[index].name),
                          subtitle: Text("@${viewedItems[index].price}"
                              "x${viewedItems[index].sqty} "
                              "=${finalized ? "" : viewedItems[index].findTotal()}"),
                          trailing: finalized
                              ? Text(viewedItems[index].total.toString())
                              : inputQuantity(index, controllerQty),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              viewedItems[index].errorMessage,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                finalized ? Text("Total: Ksh ${totalString()}") : done(context),
                finalized ? done(context) : checkOut(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton done(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.resolveWith((states) => Colors.blue),
          elevation: MaterialStateProperty.resolveWith((states) => 0)),
      child: Text(finalized ? "Done" : "Cancel"),
      onPressed: () {
        Navigator.pop(context, true);
      },
    );
  }

  ElevatedButton checkOut() {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.resolveWith((states) => Colors.blue),
          elevation: MaterialStateProperty.resolveWith((states) => 0)),
      child: const Text("Check out"),
      onPressed: () async {
        setState(() {
          toFinalize = true;
        });
        for (int i = 0; i < viewedItems.length; i++) {
          viewedItems[i].qty -= viewedItems[i].sqty;
          await Collection().addItem(viewedItems[i]);
          setState(() {
            toFinalize = false;
            finalized = true;
          });
        }
      },
    );
  }

  int sQuatity(TextEditingController control) {
    try {
      if (control.text.isEmpty) {
        return 1;
      } else {
        int qty = int.parse(control.text);
        return qty;
      }
    } catch (e) {
      return 0;
    }
  }

  TextField inputQuantity(int index, TextEditingController control) {
    return TextField(
      onSubmitted: (value) {
        try {
          if (value.isEmpty) {
            value = "1";
          } else if (int.parse(value) > viewedItems[index].qty) {
            throw Exception("not enoungh items in stock");
          }
          setState(() {
            viewedItems[index].sqty = int.parse(value);
            viewedItems[index].errorMessage = "";
            viewedItems[index].findTotal();
            total();
          });
        } catch (e) {
          value = "1";
          setState(() {
            viewedItems[index].errorMessage = e.toString();
          });
        }
      },
      controller: control,
      decoration: InputDecoration(
          hintText: "Stock: ${viewedItems[index].qty.toString()}",
          constraints: const BoxConstraints(
            maxWidth: 90,
          )),
    );
  }

  total() {
    grandTotal = 0;
    for (int i = 0; i < viewedItems.length; i++) {
      grandTotal += viewedItems[i].total;
    }
  }

  String totalString() {
    String total = grandTotal.toString();
    String result = "";
    int counter = 0;
    bool afterDec = total.contains(".") ? false : true;
    for (int i = total.length; i > 0; i--) {
      if (counter == 3) {
        result += ",";
        counter = 0;
      }
      if (afterDec) {
        counter += 1;
      }
      if (total[i - 1].compareTo(".") == 0) {
        afterDec = true;
      }
      result += total[i - 1];
    }
    result = String.fromCharCodes(result.runes.toList().reversed);
    if (result.contains(".") && result.length > result.indexOf(".") + 3) {
      result = result.replaceRange(result.indexOf(".") + 3, null, "");
    }
    return result;
  }
}
