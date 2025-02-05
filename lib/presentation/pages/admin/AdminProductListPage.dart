import 'package:chinese_bazaar/data/repositories/product_repository.dart';
import 'package:chinese_bazaar/data/sources/product_api.dart';
import 'package:chinese_bazaar/domain/entities/product.dart';
import 'package:chinese_bazaar/presentation/pages/admin/AdminProductSavePage.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AdminProductListPage extends StatefulWidget {
  @override
  _AdminProductListPageState createState() => _AdminProductListPageState();
}

class _AdminProductListPageState extends State<AdminProductListPage> {
  late Future<List<Product>> _productsFuture;
  final ProductRepository _productRepository = ProductRepository(ProductApi());
  TextEditingController _searchController = TextEditingController();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() {
  setState(() {
    _productsFuture = _productRepository.fetchAllProducts();
  });

  _productsFuture.then((products) {
    setState(() {
      _products = products;
      _filteredProducts = products;
    });

  }).catchError((error) {
  });
}

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _products.where((product) =>
        product.name.toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  

 Future<void> _deleteProduct(Product product) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Ürünü Sil"),
      content: Text("Ürünü silmek istediğinden emin misin?. Bu işlem geri alınamaz!"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text("İptal"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text("Sil", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  if (confirm == true) {
    final success = await _productRepository.deleteProduct(product);
    if (success) {
      setState(() {
        _products.removeWhere((p) => p.id == product.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Ürün başarıyla silindi"),
        backgroundColor: Colors.green,
      ));
      Future.delayed(const Duration(milliseconds: 500), () {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AdminProductListPage(),
      transitionDuration: Duration.zero, // Removes animation
    ),
  );
});
 
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Ürün Silinirken bir hata oluştu!"),
        backgroundColor: Colors.red,
      ));
    }
  }
}

  void _updateProduct(Product product) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ProductAddPage(product: product, productId: product?.id,modalTitle: "Ürünü Güncelle",isProductExist: true,),
      transitionDuration: Duration.zero, // Removes animation
    ),
  ).then((updated) {
    if (updated == true) {
      _fetchProducts(); // Refresh product list if update was successful
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 200,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Ürün Ara...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: _filterProducts,
              ),
            ),
          ),
        ],
        
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        
        
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Failed to load products"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No products found ${snapshot.error}"));
          }

          return ListView.builder(
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              return ListTile(
                title: Text("Ürün: ${product.name}"),
                subtitle:  Column(
                  children: [
                    Text("Fiyat: ${product.price}"),
                    Text("Stok: ${product.stockAmount}"),
                    Text("Açıklama: ${product.description}"),

                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _updateProduct(product),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteProduct(product),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
