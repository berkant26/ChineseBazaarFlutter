

import 'package:chinese_bazaar/data/repositories/category_repository.dart';
import 'package:chinese_bazaar/data/repositories/product_repository.dart';
import 'package:chinese_bazaar/data/sources/category_api.dart';
import 'package:chinese_bazaar/data/sources/product_api.dart';
import 'package:chinese_bazaar/domain/entities/category.dart';
import 'package:chinese_bazaar/domain/entities/product.dart';
import 'package:chinese_bazaar/domain/entities/productImage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';


class ProductAddPage extends StatefulWidget {
  const ProductAddPage({super.key, this.productId, this.product,this.modalTitle,this.isProductExist});
 final int? productId; // Nullable, used for updating an existing product
  final Product? product; // Optional existing product data
  final String? modalTitle;
  final bool? isProductExist;
  @override
  State<ProductAddPage> createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _productNameController ;
  late TextEditingController  _productPriceController ;
  late  TextEditingController   _stockAmountController ;
  late TextEditingController   _descriptionController;
  int? _selectedCategoryId;
  
  List<Category> _categories = [];
  List<XFile> _selectedImages = [];
  List<ProductImage> _productsImages = [];
List<ProductImage> imagesToDelete = [];
  
  bool _isLoading = false;
 
   late ProductRepository productRepository = ProductRepository(ProductApi());

  @override
  void initState() {
    super.initState();
    _fetchCategories();
     _productNameController = TextEditingController(text: widget.product?.name ?? '');
    _productPriceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _stockAmountController = TextEditingController(text: widget.product?.stockAmount.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.product?.description ?? '');
    _selectedCategoryId = widget.product?.categoryId;
    // Load existing images if available
    
    _fetchProductsImages();
  
  }
  
 Future<void> _fetchProductsImages() async {
  try {
    if (widget.productId == null) {
      return;
    }

    final productImagesRepository = ProductRepository(ProductApi());
    final fetchedProductImages = await productImagesRepository.fetchProductsImage(widget.productId!);
    _productsImages = List.from(fetchedProductImages);


    // Burada fetchedProductImages ile işlem yapabilirsiniz, ancak _selectedImages'e eklemiyoruz.

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to fetch product images: $e")),
    );
  }
}

// Silinmesi gereken resimleri seçmek için
void deleteImagesFromServer() {
  if (imagesToDelete.isNotEmpty) {
    submitDeletedImages(imagesToDelete);
    // Silme işlemi başarılı olduğunda listeyi temizliyoruz
    setState(() {
      imagesToDelete.clear();
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("No images selected for deletion.")),
    );
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
  final ImagePicker picker = ImagePicker();

  try {
    final List<XFile>? pickedImages = await picker.pickMultiImage();

    if (pickedImages == null || pickedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen en az bir resim seçin.")),
      );
      return;
    }

    // En fazla 5 resim seçilmesine izin ver
    if (pickedImages.length > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('En fazla 5 resim yükleyebilirsin.')),
      );
    }

    setState(() {
      _selectedImages = pickedImages.take(5).toList(); // İlk 5 resmi al
    });

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Hata oluştu: $e')),
    );
  }
}

  Future<void> _addProduct() async {

   
  if (_formKey.currentState!.validate() && _selectedCategoryId != null && _selectedImages.isNotEmpty) {
    final product = Product.create(
      id: null,
      name: _productNameController.text,
      price: double.tryParse(_productPriceController.text) ?? 0.0,
      categoryId: _selectedCategoryId!,
      stockAmount: int.tryParse(_stockAmountController.text) ?? 0,
      description: _descriptionController.text,
      imageUrl: "", // Backend'de bu alan kullanılmayabilir
    );


   var successProduct = await productRepository.addProduct(product);
   Logger log = new Logger();
   log.e('API Response: ${successProduct.toString()}');
   var successProductImage = await productRepository.uploadProductImages(successProduct.productId!, _selectedImages);
if (successProduct.success && successProductImage) {
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


Future<void> submitDeletedImages(List<ProductImage> imagesToDelete) async {
  try {
    // Silinmek istenen resimleri backend'e gönder
    final deleteSuccess = await productRepository.deleteProductImages(imagesToDelete);
    if (!deleteSuccess) {
      return;
    }

    // Başarı mesajı göster
  } catch (e) {
  }
}




Future<void> _updateProduct() async {
 
  if (!_formKey.currentState!.validate() && _selectedCategoryId == null && _productsImages.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tüm alanları doldur ve Fotoğraf Seç')),
    );
    return;
  }

  if (imagesToDelete.isNotEmpty) { 
    bool deleteResult = await productRepository.deleteProductImages(imagesToDelete);
    if (!deleteResult) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete some images.')),
      );
      return;
    }
  }
  //  resim eklenmediyse sadece silindiyse yada hiçbiri olmadıysa?

  final updatedProduct = Product.create(
    id: widget.productId!,
    name: _productNameController.text,
    price: double.tryParse(_productPriceController.text) ?? 0.0,
    categoryId: _selectedCategoryId!,
    stockAmount: int.tryParse(_stockAmountController.text) ?? 0,
    description: _descriptionController.text,
    imageUrl: "", // Image will be handled separately
  );

  var productUpdated = await productRepository.updateProduct(updatedProduct, widget.productId!);
   if(imagesToDelete.isNotEmpty){

        deleteImagesFromServer();
    }
  if(_selectedImages.isNotEmpty)
  {
     

  }

  if (productUpdated.success) {
  
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ürün güncellendi!')),
    );
    Navigator.pop(context);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ürün güncellerken hata oluştu.')),
    );
  }
}




  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600; // Adjust based on your screen width preference

    return Scaffold(
      appBar: AppBar(title:  Text(widget.modalTitle ?? 'Ürün Ekle')),
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
                            return 'Ürün Fiyatı Girin';
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
                        decoration: const InputDecoration(labelText: 'Aciklama',hintText: "Ürüne ait kodu bu alana  girmeyi unutma!"),
                        
                        
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
                      

                      Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    // Show existing product images
    ..._productsImages.map((productImage) {
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _productsImages.remove(productImage);
                _productsImages.insert(0, productImage);
              });
            },
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Image.network(
                  productImage.imageUrl,  // Assuming imageUrl is stored in the DB
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                if (_productsImages.isNotEmpty && _productsImages.first == productImage)
                  const Positioned(
                    top: 4,
                    right: 4,
                    child: Icon(Icons.star, color: Colors.amber),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                imagesToDelete.add(productImage);
                _productsImages.remove(productImage);
              });
            },
          ),
        ],
      );
    }),

    // Show newly selected images
    ..._selectedImages.map((image) {
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedImages.remove(image);
                _selectedImages.insert(0, image);
              });
            },
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Image.file(
                  File(image.path),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                if (_selectedImages.isNotEmpty && _selectedImages.first == image)
                  const Positioned(
                    top: 4,
                    right: 4,
                    child: Icon(Icons.star, color: Colors.amber),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                _selectedImages.remove(image);
              });
            },
          ),
        ],
      );
    }),
  ],
),
        const SizedBox(height: 10),
        Center(child: Text("kapak resmi  olacak fotoğrafa tıkla")),
ElevatedButton(
                        onPressed: _pickImages,
                        child: const Text('Fotoğraf Yükle'),
                      ),

                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: widget.isProductExist != null && widget.isProductExist! ? _updateProduct : _addProduct,
                        style: ElevatedButton.styleFrom(backgroundColor:Colors.orange,shadowColor:Colors.orangeAccent ),
                        child: const Text('Kaydet'),
                        
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