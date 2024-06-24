import 'package:flutter/material.dart';

class DetailTransaksiScreen extends StatelessWidget {
  const DetailTransaksiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF164863),
      appBar: AppBar(
        backgroundColor: const Color(0xFF164863),
        title: const Text('Detail Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transaction ID: 12345',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              'Date: 2023-06-24',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              'Items:',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Card(
              color: const Color(0xFF2E4E62),
              child: ListTile(
                title: const Text(
                  'Seblak Original',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  'Qty: 2\nRp. 30.000',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
            const Card(
              color: Color(0xFF2E4E62),
              child: ListTile(
                title: Text(
                  'Seblak Spicy',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Qty: 1\nRp. 20.000',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('BACK TO HOME', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
