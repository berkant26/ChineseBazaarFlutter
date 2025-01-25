import 'package:chinese_bazaar/presentation/pages/admin/ProductAddPage.dart';
import 'package:flutter/material.dart';

class AdminPanelPage extends StatelessWidget {
  const AdminPanelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the Product Add Page
                Navigator.push(
                  context,
                  PageRouteBuilder(pageBuilder: (context,animation,secondaryAnimation) => const ProductAddPage()),
                );
              },
              child: const Text('Ürün Ekle'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Product List Page (if you have it)
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const ProductListPage()),
                // );
              },
              child: const Text('Ürün Güncelle/Sil'),
            ),
            const SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }
}
