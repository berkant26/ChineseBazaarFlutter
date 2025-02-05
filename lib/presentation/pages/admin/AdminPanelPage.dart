import 'package:chinese_bazaar/presentation/pages/admin/AdminProductListPage.dart';
import 'package:chinese_bazaar/presentation/pages/admin/AdminProductSavePage.dart';
import 'package:chinese_bazaar/presentation/pages/product_list_page.dart';
import 'package:flutter/material.dart';

class AdminPanelPage extends StatelessWidget {
  const AdminPanelPage({super.key});

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
                  PageRouteBuilder(pageBuilder: (context,animation,secondaryAnimation) => const ProductAddPage(modalTitle: "Ürün Ekle",)),
                );
              },
              child: const Text('Ürün Ekle'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(pageBuilder: (context,animation,secondaryAnimation) =>  AdminProductListPage()),
                );
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
