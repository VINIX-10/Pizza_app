class Topping {
  final String name; // Nama topping (contoh: "Extra Cheese")
  final double price; // Harga per topping
  bool isSelected; // Status: dipilih atau tidak

  Topping({required this.name, required this.price, this.isSelected = false});
}
