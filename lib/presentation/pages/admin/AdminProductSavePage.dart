
import 'package:chinese_bazaar/data/repositories/category_repository.dart';
import 'package:chinese_bazaar/data/repositories/product_repository.dart';
import 'package:chinese_bazaar/data/sources/category_api.dart';
import 'package:chinese_bazaar/data/sources/product_api.dart';
import 'package:chinese_bazaar/domain/entities/category.dart';
import 'package:chinese_bazaar/domain/entities/product.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:logger/logger.dart';

class ProductAddPage extends StatefulWidget {
  const ProductAddPage({super.key, this.productId, this.existingProduct});
 final int? productId; // Nullable, used for updating an existing product
  final Product? existingProduct; // Optional existing product data
  @override
  State<ProductAddPage> createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _stockAmountController = TextEditingController();
  final _descriptionController = TextEditingController();
  int? _selectedCategoryId;
  
  List<Category> _categories = [];
  List<PlatformFile> _selectedImages = [];
  PlatformFile? _coverPhoto;
  bool _isLoading = false;
  var logger=  Logger();
 
   late ProductRepository productRepository = ProductRepository(ProductApi());

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    if (widget.existingProduct != null) {
    _productNameController.text = widget.existingProduct!.name;
    _productPriceController.text = widget.existingProduct!.price.toString();
    _stockAmountController.text = widget.existingProduct!.stockAmount.toString();
    _descriptionController.text = widget.existingProduct!.description;
    _selectedCategoryId = widget.existingProduct!.categoryId;
    // Load existing images if available
  }
  }

  Future<void> _fetchCategories() async {
    setState(() => _isLoading = true);
    try {
      final categoryRepository = CategoryRepository(CategoryApi());
      final fetchedCategories = await categoryRepository.fetchCategories();
      setState(() {
        _categories = fetchedCategories;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch categories: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImages() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true, // Includes file bytes in the result
    );

    if (result != null && result.files.isNotEmpty) {
      if (result.files.length <= 5) {
        setState(() {
          _selectedImages = result.files;
          _coverPhoto = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You can only upload up to 5 photos.')),
        );
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to pick images: $e')),
    );
  }
}


  Future<void> _addProduct() async {
   
  if (_formKey.currentState!.validate() && _selectedCategoryId != null && _selectedImages.length > 0) {
    final product = Product.create(
      id: null,
      name: _productNameController.text,
      price: double.tryParse(_productPriceController.text) ?? 0.0,
      categoryId: _selectedCategoryId!,
      stockAmount: int.tryParse(_stockAmountController.text) ?? 0,
      description: _descriptionController.text,
      imageUrl: "", // Backend'de bu alan kullanılmayabilir
    );

    logger.d("description = ${product.description}");
    logger.d("stockAmount = ${product.stockAmount}");
    logger.d("images lenght = ${_selectedImages.length}");

   var successProduct = await productRepository.addProduct(product);
   var successProductImage = await productRepository.uploadProductImages(successProduct.productId!, _selectedImages);
if (successProduct.success && successProductImage) {
  logger.d("eklendi");
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Ürün eklendi')),
    
  );
  Navigator.pop(context);
}

  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tüm alanları doldurun,fotoğraf yükleyin ve kategori seçin')),
    );
  }
}

Future<void> _updateProduct() async {
  if (_formKey.currentState!.validate() && _selectedCategoryId != null && _selectedImages.isNotEmpty) {
    if (widget.productId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product ID is missing.')),
      );
      return;
    }

    final updatedProduct = Product.create(
      id: widget.productId!,  // Ensure productId is passed correctly
      name: _productNameController.text,
      price: double.tryParse(_productPriceController.text) ?? 0.0,
      categoryId: _selectedCategoryId!,
      stockAmount: int.tryParse(_stockAmountController.text) ?? 0,
      description: _descriptionController.text,
      imageUrl: ""
    );

    var productResult = await productRepository.updateProduct(updatedProduct,widget.productId!);
    var productImagesResult = await productRepository.updateProductImages(productResult.productId!, _selectedImages);
    
    if (productResult.success && productImagesResult) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update product.')),
      );
    }
  }
}





  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600; // Adjust based on your screen width preference

    return Scaffold(
      appBar: AppBar(title: const Text('Ürün Ekle')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(isLargeScreen ? 32.0 : 16.0), // Dynamic padding
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _productNameController,
                        decoration: const InputDecoration(labelText: 'Ürün Adı'),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Ürün Adı Girin' : null,
                      ),
                      TextFormField(
                        controller: _productPriceController,
                        decoration: const InputDecoration(labelText: 'Fiyat'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ürün Fiyatı Girin ';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Enter a valid price';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _stockAmountController,
                        decoration: const InputDecoration(labelText: 'Stok Adedi'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value == null || int.tryParse(value) == null ? 'Stok Adedi girin' : null,
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(labelText: 'Aciklama'),
                        maxLines: 3,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Ürün Açıklaması gir' : null,
                      ),
                      DropdownButtonFormField<int>(
                        value: _selectedCategoryId,
                        items: _categories
                            .map(
                              (category) => DropdownMenuItem<int>(
                                value: category.id,
                                child: Text(category.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => setState(() => _selectedCategoryId = value),
                        decoration: const InputDecoration(labelText: 'Kategori'),
                        validator: (value) => value == null ? 'Kategori sec' : null,
                      ),
                      const SizedBox(height: 10),
                      

                      if (_selectedImages.isNotEmpty)
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _selectedImages
              .map((image) => GestureDetector(
                    onTap: () {
                      setState(() {
                        // Move the tapped image to the first position
                        _selectedImages.remove(image);
                        _selectedImages.insert(0, image);
                      });
                    },
                    
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.file(
                          File(image.path!),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        if (_selectedImages.indexOf(image) == 0)
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                      ],
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 10),
        Center(child: Text("kapak resmi  olacak fotoğrafa tıkla")),
ElevatedButton(
                        onPressed: _pickImages,
                        child: const Text('Fotoğrafları Yükle'),
                      ),

                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _addProduct,
                        style: ElevatedButton.styleFrom(backgroundColor:Colors.orange,shadowColor:Colors.orangeAccent ),
                        child: const Text('Ürünü Ekle'),
                        
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productPriceController.dispose();
    _stockAmountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
