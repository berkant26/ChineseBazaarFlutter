import 'package:chinese_bazaar/data/sources/address_api.dart';
import 'package:chinese_bazaar/data/sources/login_api.dart';
import 'package:flutter/material.dart';
import 'package:chinese_bazaar/data/sources/order_api.dart';

class SiparislerimPage extends StatefulWidget {
  final int? userId;
  const SiparislerimPage({super.key, required this.userId});

  @override
  _SiparislerimPageState createState() => _SiparislerimPageState();
}

class _SiparislerimPageState extends State<SiparislerimPage> {
  late Future<List<Map<String, dynamic>>?>? orders ;
  final AddressApi _addressApi = AddressApi();
  bool? isAdmin;
  
  Map<String, dynamic>? _userAddress;

  String formatDate(String date) {
  DateTime parsedDate = DateTime.parse(date);
  return '${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}';
}

  @override
  void initState() {
    orders = null;
    super.initState();
    checkAdminStatus();
   
  }

  

  
  void checkAdminStatus() async {
    bool adminStatus = await AuthApi().isAdmin();
    setState(() {
      isAdmin = adminStatus;
      orders = isAdmin! 
          ? OrderApi().fetchAllOrders()
          : OrderApi().fetchUserOrders(widget.userId!);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Siparişlerim"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
           return const Center(child: Text('Sipariş yok'));
          }

          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('Sipariş yok'));
          }

          var ordersList = snapshot.data!;

          return ListView.builder(
            itemCount: ordersList.length,
            itemBuilder: (context, index) {
              var orderData = ordersList[index];
              var order = orderData['order']; // Access order
              var orderItems = orderData['orderItems']; // Access orderItems
              var userInfo = orderData['userAddress'];
              if (order == null || orderItems == null || orderItems is! List) {
                return const Center(child: Text('Bir şeyler ters gitti, Tekrar deneyin'));
              }

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  title: Text('Sipariş No #${order['id']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tarih: ${order['orderDate'] != null ? formatDate(order['orderDate']) : 'N/A'}',
                      ),
                      Text('Toplam Tutar: ${order['totalPrice'] ?? 'N/A'} TL'),
                      ...orderItems.map<Widget>((item) {
                        if (item is Map<String, dynamic>) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('*****************'),

                            Text('Ürün: ${item['productName'] ?? 'N/A'}'),
                            Text('Miktar: ${item['quantity'] ?? 'N/A'}'),
                            Text('Fiyat: ${item['price'] ?? 'N/A'} TL'),
                            Text('Açıklama: ${item['productDescription'] ?? 'N/A'}'),
                          ],
                        );
                      }
                      else {
                          return const Text('Invalid item data');
                        }
                      }),
                      SizedBox(height: 10,),
                      Text(' -- Alıcı iletişim Bilgileri --'),
                     Text('Ad: ${userInfo['firstName'] ?? '-'}'),
                     Text('Soyad: ${userInfo['lastName'] ?? '-'}'),
                     Text('il: ${userInfo['city'] ?? '-'}'),
                     Text('Ilçe: ${userInfo['district'] ?? '-'}'),
                     Text('Mahalle: ${userInfo['neighborhood'] ?? '-'}'),
                     Text('Telefon: ${userInfo['phoneNumber'] ?? '-'}'),
                     Text('Açık adres: ${userInfo['fullAddress'] ?? '-'}'),

                    
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
    
  }
  
  
}
