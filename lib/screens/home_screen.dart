import 'package:ecommerce/model/cart_item.dart';
import 'package:ecommerce/model/category.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as custom_badge;
import 'package:ecommerce/model/product.dart';
import 'package:ecommerce/routes/app_routes.dart';
import 'package:ecommerce/screens/detail_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecommerce/network/api.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<List<MenuItem>> fetchMenuItems() async {
    final response = await Network().getData('/api/tokoonline/resto');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => MenuItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load menu items');
    }
  }

  Future<List<CategoryProduct>> fetchCategories() async {
    final response = await Network().getData('/api/tokoonline/category');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((item) => CategoryProduct.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<MenuItem>> fetchMenuItemsByCategory(int categoryId) async {
    final response = await Network().getData('/api/tokoonline/resto');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      return jsonResponse
          .map((item) => MenuItem.fromJson(item))
          .where((element) => element.categoryId == categoryId)
          .toList();
    } else {
      throw Exception('Failed to load menu items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF164863),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF123456), Colors.black],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSearchBar(context),
                const SizedBox(height: 16),
                _buildCarouselWidget(),
                const SizedBox(height: 16),
                _buildBalanceSection(),
                const SizedBox(height: 16),
                FutureBuilder<List<CategoryProduct>>(
                  future: fetchCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No categories found');
                    } else {
                      return Column(
                        children: snapshot.data!.map((category) {
                          return Column(
                            children: [
                              _buildSectionTitle(context, category.name),
                              FutureBuilder<List<MenuItem>>(
                                future: fetchMenuItemsByCategory(category.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Text('No items found');
                                  } else {
                                    return _buildMenuSlider(
                                        context, snapshot.data!);
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
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

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
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
        ),
        const SizedBox(width: 16),
        custom_badge.Badge(
          position: custom_badge.BadgePosition.topEnd(top: 0, end: 3),
          badgeContent: const Text('99+',
              style: TextStyle(color: Colors.white, fontSize: 8)),
          child: IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 16),
        custom_badge.Badge(
          position: custom_badge.BadgePosition.topEnd(top: 0, end: 3),
          badgeContent: Consumer<Cart>(
            builder: (context, cart, _) {
              int itemCount = cart.items.length;
              return Text(
                itemCount > 99 ? '99+' : itemCount.toString(),
                style: TextStyle(color: Colors.white, fontSize: 8),
              );
            },
          ),
          child: IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.cart);
            },
          ),
        ),
        const SizedBox(width: 16),
        CircleAvatar(
          backgroundImage:
              NetworkImage('https://ui-avatars.com/api/?name=Syahrul+Alif'),
        ),
      ],
    );
  }

  Widget _buildCarouselWidget() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF123456), // Adjust to match the background color
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(5.0), // Margin around the widget
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/desert.png', // Replace with your image URL or asset
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5F8),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8.0), // Added padding to container
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner, color: Colors.grey),
            onPressed: () {
              // Handle scanner button press
            },
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.grey[300],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.account_balance_wallet, color: Colors.grey),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Rp 1.000.000',
                          style: TextStyle(color: Colors.black)),
                      Text('Isi Saldo', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.grey[300],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.monetization_on, color: Colors.grey),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('50.000', style: TextStyle(color: Colors.black)),
                      Text('Koin', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 18)),
          Text('Lihat Semua',
              style: TextStyle(color: Colors.white.withOpacity(0.7))),
        ],
      ),
    );
  }

  Widget _buildMenuSlider(BuildContext context, List<MenuItem> items) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 20),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          height: 280,
          child: ListView(
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(width: 16),
              ...items.map((item) => _buildMenuItem(context, item)).toList(),
              SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItem item) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, bottom: 8.0),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: const Color(0xFF1E2A38),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                item.image,
                fit: BoxFit.cover,
                height: 120,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.grey,
                    child: const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  );
                },
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('Stock: ${item.currentStock ?? 'N/A'}',
                          style: const TextStyle(
                              fontSize: 14, color: Color(0xFFFACA15))),
                      const SizedBox(height: 4),
                      Text(item.sellingPrice,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(item: {
                                    'name': item.name,
                                    'image': item.image,
                                    'description': item.description,
                                    'id': item.id.toString(),
                                    'selling_price': item.sellingPrice,
                                  }),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            child: const Text('Detail',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(item: {
                                    'name': item.name,
                                    'image': item.image,
                                    'description': item.description,
                                    'id': item.id.toString(),
                                    'selling_price': item.sellingPrice,
                                  }),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            child: const Text('Add to Cart',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
