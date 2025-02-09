class Order {
  final int? id;
  final int? userId;
  final int? userAddressId;

  final double? totalPrice;
  final DateTime? orderDate;
  final bool paymentStatus;
  final List<OrderItem> orderItems;

  Order({
    required this.id,
    required this.userId,
    required this.userAddressId,

    required this.totalPrice,
    required this.orderDate,
    required this.paymentStatus,
    required this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var list = json['orderItems'] as List;
    List<OrderItem> itemsList = list.map((i) => OrderItem.fromJson(i)).toList();

    return Order(
      id: json['id'],
      userId: json['userId'],
      userAddressId: json['userAddressId'],

      totalPrice: json['totalPrice'],
      orderDate: DateTime.parse(json['orderDate']),
      paymentStatus: json['paymentStatus'],
      orderItems: itemsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'totalPrice': totalPrice,
      'userAddressId': userAddressId,
      'orderDate': orderDate?.toIso8601String(),
      'paymentStatus': paymentStatus,
      'orderItems': orderItems.map((item) => item.toJson()).toList(),
    };
  }
}
class OrderItem {
  final int productId;
  final int quantity;
  final double price;

  OrderItem({required this.productId, required this.quantity, required this.price});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}
class OrderRequestDto {
  final Order order;
  final List<OrderItem> orderItems;

  OrderRequestDto({required this.order, required this.orderItems});

  Map<String, dynamic> toJson() {
    return {
      "order": order.toJson(), // Ensure Order class has toJson()
      "orderItems": orderItems.map((item) => item.toJson()).toList(), // Ensure OrderItem class has toJson()
    };
    
  }
  factory OrderRequestDto.fromJson(Map<String, dynamic> json) {
    return OrderRequestDto(
      order: Order.fromJson(json['order']),
      orderItems: List<OrderItem>.from(
        json['orderItems'].map((item) => OrderItem.fromJson(item)),
      ),
    );
  }
}
