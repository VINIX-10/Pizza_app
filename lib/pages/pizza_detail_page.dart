// lib/pages/pizza_detail_page.dart
import 'package:flutter/material.dart';
import 'package:pizza/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import '../models/pizza.dart';
import '../models/topping.dart';

class PizzaDetailPage extends StatefulWidget {
  final Pizza pizza;
  const PizzaDetailPage({super.key, required this.pizza});

  @override
  State<PizzaDetailPage> createState() => _PizzaDetailPageState();
}

class _PizzaDetailPageState extends State<PizzaDetailPage> {
  String selectedSize = 'Medium';
  final List<Topping> toppings = [
    Topping(name: 'Jalapeno', price: 3000),
    Topping(name: 'Keju', price: 4000),
    Topping(name: 'BBQ', price: 3500),
    Topping(name: 'Chicken', price: 5000),
    Topping(name: 'Extra Pepperoni', price: 6000),
  ];

  double getPizzaPrice() {
    // asumsikan model Pizza punya 'price' (int/double)
    double base = (widget.pizza.price is int)
        ? (widget.pizza.price as int).toDouble()
        : (widget.pizza.price as double? ?? 0.0);

    // contoh: ubah harga berdasarkan ukuran
    switch (selectedSize) {
      case 'Small':
        base -= 5000;
        break;
      case 'Large':
        base += 7000;
        break;
      case 'Xtra Large':
        base += 12000;
        break;
      default:
        // Medium: tetap base
        break;
    }

    // tambahkan topping
    for (var t in toppings) {
      if (t.isSelected) base += t.price;
    }

    return base;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pizza.name),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // gambar besar
            SizedBox(
              height: 220,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.pizza.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.local_pizza, size: 80),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.pizza.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text("Base price: Rp ${widget.pizza.price}"),
            const SizedBox(height: 12),

            // ukuran
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Pilih Ukuran:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: ['Small', 'Medium', 'Large', 'Xtra Large'].map((s) {
                return ChoiceChip(
                  label: Text(s),
                  selected: selectedSize == s,
                  onSelected: (_) {
                    setState(() {
                      selectedSize = s;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Topping Tambahan:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: toppings.map((t) {
                return FilterChip(
                  label: Text('${t.name} (+Rp${t.price.toInt()})'),
                  selected: t.isSelected,
                  onSelected: (val) {
                    setState(() {
                      t.isSelected = val;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // tombol tambah ke keranjang
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: Rp ${getPizzaPrice().toInt()}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final cart = Provider.of<CartProvider>(
                      context,
                      listen: false,
                    );
                    final totalPrice = getPizzaPrice();
                    final selectedToppings = toppings
                        .where((t) => t.isSelected)
                        .toList();

                    cart.addToCart(
                      widget.pizza,
                      selectedSize,
                      selectedToppings,
                      totalPrice,
                    );

                    showSmoothDynamicToast(
                      context,
                      "${widget.pizza.name} ($selectedSize) ditambahkan!",
                    );
                  },
                  child: const Text("Tambah ke Keranjang"),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

//animasi pop up
void showSmoothDynamicToast(BuildContext context, String text) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  final controller = AnimationController(
    vsync: Navigator.of(context),
    duration: const Duration(milliseconds: 380),
  );

  final animation = CurvedAnimation(
    parent: controller,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );

  entry = OverlayEntry(
    builder: (context) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final value = animation.value;

          // IN:  -20 → 0
          // OUT: 0 → -20
          final slideY = -20 + (20 * value);

          return Transform.translate(
            offset: Offset(0, slideY),
            child: Transform.scale(
              scale: 0.9 + (value * 0.1),
              child: Material(
                color: Colors.transparent,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 48),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_pizza,
                          color: Colors.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );

  overlay.insert(entry);

  controller.forward();

  // keluar smooth SLIDE UP
  Future.delayed(const Duration(milliseconds: 1500)).then((_) async {
    await controller.reverse(); // ini animasi naik lagi ke atas
    entry.remove();
    controller.dispose();
  });
}
