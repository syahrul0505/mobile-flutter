import 'package:ecommerce/network/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailTransaksiScreen extends StatefulWidget {
  const DetailTransaksiScreen({Key? key}) : super(key: key);

  @override
  _DetailTransaksiScreenState createState() => _DetailTransaksiScreenState();
}

class _DetailTransaksiScreenState extends State<DetailTransaksiScreen> {
  List<Transaction> transactions = [];
  int lastIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await Network().getData('/api/tokoonline/detail-transaksi');
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        transactions = List<Transaction>.from(
            data.map((item) => Transaction.fromJson(item)));
        lastIndex = transactions.length - 1;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF164863),
      appBar: AppBar(
        backgroundColor: const Color(0xFF164863),
        title: const Text('Detail Transaksi'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transactions[lastIndex].id.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Date: 2024-06-24',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Items:',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: transactions[lastIndex].orderDetails.length,
                    itemBuilder: (context, index) {
                      final item = transactions[lastIndex].orderDetails[index];
                      return Card(
                        color: const Color(0xFF2E4E62),
                        child: ListTile(
                          title: Text(
                            item.name ?? 'Unknown',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            'Qty: ${item.qty}\nRp. ${item.price}',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      );
                    },
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
                    child: const Text('BACK TO HOME',
                        style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
    );
  }
}

class Transaction {
  final int id;
  final String name;
  final String phone;
  final int? qty;
  final String statusPembayaran;
  final List<OrderDetail> orderDetails;

  Transaction({
    required this.id,
    required this.name,
    required this.phone,
    required this.qty,
    required this.statusPembayaran,
    required this.orderDetails,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      qty: json['qty'],
      statusPembayaran: json['status_pembayaran'],
      orderDetails: List<OrderDetail>.from(
          json['order_details'].map((item) => OrderDetail.fromJson(item))),
    );
  }
}

class OrderDetail {
  final int id;
  final String? name;
  final int qty;
  final String price;

  OrderDetail({
    required this.id,
    required this.name,
    required this.qty,
    required this.price,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'],
      name: json['name'],
      qty: json['qty'],
      price: json['price_discount'],
    );
  }
}
