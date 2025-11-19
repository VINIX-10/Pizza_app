import 'package:flutter/foundation.dart';
import '../models/pizza.dart';
import '../models/topping.dart';

class CartItem {
  final Pizza pizza;
  final String size;
  final List<Topping> toppings;
  final double totalPrice;

  CartItem({
    required this.pizza,
    required this.size,
    required this.toppings,
    required this.totalPrice,
  });
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalAmount {
    double total = 0;
    for (var item in _items) {
      total += item.totalPrice;
    }
    return total;
  }

  void addToCart(
    Pizza pizza,
    String size,
    List<Topping> toppings,
    double totalPrice,
  ) {
    _items.add(
      CartItem(
        pizza: pizza,
        size: size,
        toppings: List.from(toppings), // salin data topping
        totalPrice: totalPrice,
      ),
    );
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
