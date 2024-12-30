class ProductImage{
  final int Id;
  final int  ProductId;
  final String imageUrl;
  ProductImage({
    required this.Id,
    required this.imageUrl,
    required this.ProductId
  }) ;

Map<String,dynamic> toJson(){
  return{
    'Id':Id,
    'ProductId':ProductId,
    'ImageUrl':imageUrl,
  };
}

  factory ProductImage.fromJson(Map<String,dynamic> json){
    return ProductImage(
      Id: json['Id'] as int,
       imageUrl: json['imageUrl'] ??'null',
        ProductId: json['ProductId'] ?? '',);
    
  }

}