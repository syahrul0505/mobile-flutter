// model/product.dart
import 'package:flutter/foundation.dart';

class CartItem {
  final int id;
  final String name;
  final String image;
  int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }
}

class Cart extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(int id, String name, String image, double price) {
    final existingItem = _items.firstWhere((item) => item.id == id,
        orElse: () => CartItem(
            id: id, name: name, image: image, quantity: 0, price: price));
    if (existingItem.quantity == 0) {
      _items.add(CartItem(
          id: id, name: name, image: image, quantity: 1, price: price));
    } else {
      existingItem.quantity++;
    }
  }

  void removeItem(int id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(0, (total, item) => total + item.price * item.quantity);
  }
}
