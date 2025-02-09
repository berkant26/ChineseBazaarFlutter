import 'package:flutter/material.dart';
import 'package:chinese_bazaar/data/sources/order_api.dart';

class SiparislerimPage extends StatefulWidget {
  final int? userId;

  SiparislerimPage({required this.userId});

  @override
  _SiparislerimPageState createState() => _SiparislerimPageState();
}

class _SiparislerimPageState extends State<SiparislerimPage> {
  late Future<Map<String, dynamic>?> orders;

  @override
  void initState() {
    super.initState();
    orders = OrderApi().fetchOrders(widget.userId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Siparişlerim"),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: orders,
        builder: (context, snapshot) {
          // If the connection is waiting, show a loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If there's an error, log and display the error message
          if (snapshot.hasError) {
            print('Error fetching orders: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // If no data is available, show a message
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No orders found.'));
          }

          // Extract order and orderItems from the response
          var order = snapshot.data!['order']; // Access 'order'
          var orderItems = snapshot.data!['orderItems']; // Access 'orderItems'

          // Check if the order or orderItems are null
          if (order == null || orderItems == null || orderItems is! List) {
            return const Center(child: Text('Invalid order data.'));
          }

          // Log the order ID
          print('Order ID: ${order['id']}');

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                      ),
                      title: Text(
                        'Sipariş No #${order['id']}',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tarih: ${order['orderDate'] ?? 'N/A'}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Toplam Tutar ${order['totalPrice'] ?? 'N/A'} TL',
                            style: TextStyle(fontSize: 14),
                          ),
                          ...orderItems.map<Widget>((item) {
                            // Ensure item is a Map and contains required keys
                            if (item is Map<String, dynamic>) {
                              return Text(
                                'Ürün: ${item['productName'] ?? 'N/A'}, Quantity: ${item['quantity'] ?? 'N/A'}, Fiyat: ${item['price'] ?? 'N/A'} TL',
                                style: TextStyle(fontSize: 12),
                              );
                            } else {
                              return Text(
                                'Invalid item data',
                                style: TextStyle(fontSize: 12),
                              );
                            }
                          }).toList(),
                        ],
                      ),
                      // trailing: Icon(
                      //   (order['paymentStatus'] ?? false) ? Icons.check : Icons.close,
                      //   color: (order['paymentStatus'] ?? false) ? Colors.green : Colors.red,
                      // ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}