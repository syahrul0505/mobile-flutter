import 'package:flutter/material.dart';

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
            _buildCartItem('Nasi Goreng Modern', 'Pedas, No Acar', 45000),
            _buildCartItem('Mie Goreng Modern', 'Sedang', 35000),
            const Spacer(),
            _buildPriceDetails(130000, 11),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle payment button press
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
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        selectedItemColor: const Color(0xFF164863),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildCartItem(String name, String details, double price) {
    return Card(
      color: const Color(0xFF2E4E62),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Image.asset('assets/desert.png', width: 50, height: 50, fit: BoxFit.cover),
        title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text('$details\nRp. ${price.toStringAsFixed(3)}', style: const TextStyle(color: Colors.white70)),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.orange),
          onPressed: () {
            // Handle delete cart item
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
          Text('Rp. ${amount.toStringAsFixed(3)}', style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}
