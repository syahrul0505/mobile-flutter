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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSearchBar(context),
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
              NetworkImage('https://ui-avatars.com/api/?name=Imam+Syaraf'),
        ),
      ],
    );
  }

  Widget _buildBalanceSection() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF98BEC8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: const [
                Text('Rp 1.000.000', style: TextStyle(color: Colors.white)),
                Text('Isi Saldo', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF98BEC8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: const [
                Text('50.000', style: TextStyle(color: Colors.white)),
                Text('Koin', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
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
    return SizedBox(
      height: 280,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildMenuItem(context, items[index]);
        },
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF164863), // Matching parent background color
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('Stock: ${item.currentStock ?? 'N/A'}',
                      style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFACA15))), // Updated color
                  const SizedBox(height: 4),
                  Text(item.sellingPrice,
                      style: const TextStyle(fontSize: 14, color: Colors.red)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle detail action
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
                        ),
                        child: const Text('Detail'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to detail screen with item details
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
                        ),
                        child: const Text('Add to Cart'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
