import 'package:ecommerce/model/cart_item.dart';
import 'package:ecommerce/network/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Add this import statement

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF164863),
      appBar: AppBar(
        backgroundColor: const Color(0xFF164863),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Seblak The Nuruls',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFF98BEC8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {},
          ),
          const CircleAvatar(
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Consumer<Cart>(
              builder: (context, cart, _) {
                return Column(
                  children: cart.items.map((item) {
                    return _buildCartItem(context, item.id, item.name,
                        item.quantity, item.price, item.image);
                  }).toList(),
                );
              },
            ),
            const Spacer(),
            Consumer<Cart>(
              builder: (context, cart, _) {
                return _buildPriceDetails(cart.totalPrice, 10);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                const url = '/api/checkout';
                final cart = Provider.of<Cart>(context, listen: false);
                final data = {
                  'qty': cart.totalItems,
                  'totalPrice': cart.totalPrice + (cart.totalPrice * 10 / 100),
                  'subTotal': cart.totalPrice,
                  'items': cart.items
                      .map((item) => {
                            'name': item.name,
                            'quantity': item.quantity,
                            'price_discount': item.price,
                          })
                      .toList(),
                };

                final response = await Network().postData(data, url);

                if (response.statusCode == 200) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Success'),
                        content: const Text('Payment success'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              cart.clear();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  print(response.body);
                  print(response.statusCode);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Payment failed'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('PAYMENT', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        selectedItemColor: const Color(0xFF164863),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, int id, String name, int quantity,
      double price, String image) {
    // format price to indonesia currency
    final priceString = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp. ',
      decimalDigits: 0,
    ).format(price);

    return Card(
      color: const Color(0xFF2E4E62),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        // leading: Image.asset('assets/desert.png', width: 50, height: 50, fit: BoxFit.cover),
        leading: Image.network(image, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(name,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text('Qty: ${quantity}\n${priceString}',
            style: const TextStyle(color: Colors.white70)),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.orange),
          onPressed: () {
            // Handle delete cart item
            // show dialog to confirm delete
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Delete Item'),
                  content:
                      const Text('Are you sure you want to delete this item?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () {
                        final cart = Provider.of<Cart>(context, listen: false);
                        cart.removeItem(id);
                        Navigator.of(context).pop();
                      },
                      child: const Text('DELETE'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPriceDetails(double harga, int taxPercentage) {
    double tax = harga * taxPercentage / 100;
    double total = harga + tax;

    return Column(
      children: [
        _buildPriceRow('Harga', harga),
        _buildPriceRow('PPN $taxPercentage%', tax),
        const Divider(color: Colors.white70),
        _buildPriceRow('Total', total),
      ],
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    // number format to indonesia currency

    final amountInIdr = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp. ',
      decimalDigits: 0,
    ).format(amount);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 16)),
          Text('${amountInIdr}',
              style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}
