// lib/widgets/pizza_card.dart
import 'package:flutter/material.dart';
import '../models/pizza.dart';
import '../pages/pizza_detail_page.dart';

class PizzaCard extends StatelessWidget {
  final Pizza pizza;

  const PizzaCard({super.key, required this.pizza});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman detail pizza
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PizzaDetailPage(pizza: pizza)),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gambar pizza
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    pizza.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // kalau asset nggak ketemu, tampil icon biar nggak crash
                      return const Center(
                        child: Icon(Icons.local_pizza, size: 48),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Nama pizza
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Text(
                pizza.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),

            // Harga pizza
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
              child: Text(
                // pastikan model Pizza punya field 'price'
                "Rp ${pizza.price}",
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
