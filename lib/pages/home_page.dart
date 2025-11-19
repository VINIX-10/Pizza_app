import 'package:flutter/material.dart';
import '../models/pizza.dart';
import '../widgets/pizza_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Pizza> pizzas = [
    Pizza(
      name: "Pepperoni Pizza",
      price: 45000,
      image: "assets/images/pizza1.jpg",
      type: "Popular",
    ),
    Pizza(
      name: "Veggie Delight",
      price: 40000,
      image: "assets/images/pizza2.jpg",
      type: "Veggie",
    ),
    Pizza(
      name: "BBQ Chicken",
      price: 48000,
      image: "assets/images/pizza3.jpg",
      type: "All",
    ),
    Pizza(
      name: "Cheese Lovers",
      price: 50000,
      image: "assets/images/pizza4.png",
      type: "Popular",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari pizza...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),

          // 🔽 Tambahkan ini
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.red),
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
          ],

          bottom: const TabBar(
            labelColor: Colors.red,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.red,
            tabs: [
              Tab(text: "All"),
              Tab(text: "Popular"),
              Tab(text: "Veggie"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPizzaGrid("All"),
            _buildPizzaGrid("Popular"),
            _buildPizzaGrid("Veggie"),
          ],
        ),
      ),
    );
  }

  Widget _buildPizzaGrid(String type) {
    // filter berdasarkan kategori dan pencarian
    final filtered = pizzas.where((pizza) {
      final matchesType = type == "All" || pizza.type == type;
      final matchesSearch = pizza.name.toLowerCase().contains(_searchQuery);
      return matchesType && matchesSearch;
    }).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // dua kolom
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return PizzaCard(pizza: filtered[index]);
      },
    );
  }
}
