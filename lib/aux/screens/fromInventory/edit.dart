import 'package:flutter/material.dart';
import 'package:market/database/cloud.dart';

import '../../extra/item.dart';

// ignore: must_be_immutable
class EditItem extends StatefulWidget {
  Item item = Item();
  bool isNew = false;
  EditItem({super.key, required Item inItem, required bool inIsNew}) {
    item = inItem;
    isNew = inIsNew;
  }

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  final _formKey = GlobalKey<FormState>();
  Item input = Item();
  bool written = false;
  String writtingError = "";

  Future add() async {
    const CircularProgressIndicator();
    await Collection().addItem(input);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Item Details ...")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: editingForm(context),
      ),
    );
  }

  Form editingForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.isNew ? idFormField() : saveId(),
            TextFormField(
              initialValue: widget.isNew ? null : widget.item.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Name is empty!";
                }
                input.name = value;
                return null;
              },
              showCursor: true,
              decoration: inputDeco("Name", widget.item.name),
            ),
            TextFormField(
              initialValue: widget.isNew ? null : widget.item.price.toString(),
              validator: (value) {
                try {
                  if (value == null || value.isEmpty) {
                    return "Please input Price";
                  }
                  input.price = double.parse(value);
                  return null;
                } catch (e) {
                  return "Invalid number format";
                }
              },
              showCursor: true,
              decoration: inputDeco("Price", widget.item.price.toString()),
            ),
            TextFormField(
              initialValue: widget.isNew ? null : widget.item.qty.toString(),
              validator: (value) {
                try {
                  if (value == null || value.isEmpty) {
                    return "Quantity must be greater than or equal to zero";
                  }
                  input.qty = int.parse(value);
                  return null;
                } catch (e) {
                  return "Quantity must be an interger";
                }
              },
              showCursor: true,
              decoration: inputDeco("Quantity", widget.item.qty.toString()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [cancel(context), saveButton(context)],
              ),
            ),
            Text(writtingError),
          ],
        ),
      ),
    );
  }

  TextButton cancel(BuildContext context) {
    return TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Text saveId() {
    input.id = widget.item.id;
    return Text("Id : ${widget.item.id}");
  }

  TextButton saveButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data Validted')),
          );
          add();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item Saved')),
          );
          Navigator.pop(context);
        }
      },
      child: const Text('Submit'),
    );
  }

  TextFormField idFormField() {
    return TextFormField(
      initialValue: widget.isNew ? null : widget.item.id,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "You must enter ID";
        }
        try {
          int.parse(value);
          input.id = value;
          return null;
        } catch (e) {
          return "ID must be a three-digit interger\n->{e.toString()}";
        }
      },
      showCursor: true,
      decoration: inputDeco("Id", widget.item.id),
    );
  }

  InputDecoration inputDeco(String label, String actualValue) {
    return InputDecoration(
      label: Text("$label : $actualValue"),
      hintText: actualValue,
    );
  }
}
