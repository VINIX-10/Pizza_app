class Pizza {
  final String name; // Nama pizza (contoh: "Veggie Delight")
  final String image; // Path atau URL gambar pizza
  final double price; // Harga dasar pizza tanpa topping
  final List<String>
  toppings; // Daftar topping (nama-nama topping yang dipilih)
  final String size; // Ukuran pizza (Small, Medium, Large)
  final String type; // tipe pizza untuk di homepage

  // Constructor: digunakan untuk membuat objek Pizza baru
  Pizza({
    required this.name,
    required this.image,
    required this.price,
    this.toppings = const [],
    this.size = 'Medium',
    required this.type,
  });

  // Method untuk menghitung total harga pizza (harga dasar + topping)
  double get totalPrice {
    return price + (toppings.length * 1.5);
  }
}
