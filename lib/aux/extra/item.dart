class Item {
  String id;
  String name;
  int qty;
  int sqty;
  double price;
  bool selected;
  double total;
  String errorMessage = "";
  Item(
      {this.id = "ID",
      this.name = "Name",
      this.qty = 0,
      this.sqty = 1,
      this.price = 0,
      this.total = 1,
      this.selected = false});

  double findTotal() {
    total = price * sqty;
    return total;
  }

  @override
  bool operator ==(Object other) {
    return other is Item && other.runtimeType == runtimeType && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
