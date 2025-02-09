import 'package:chinese_bazaar/data/sources/order_api.dart';
import 'package:chinese_bazaar/data/sources/payment.api.dart';
import 'package:chinese_bazaar/domain/entities/Order.dart';
import 'package:chinese_bazaar/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  final double totalPrice;
  final List<Product> products;
 
  const PaymentScreen({Key? key, required this.totalPrice, required this.products}) : super(key: key);
  
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expireMonthController = TextEditingController();
  final TextEditingController _expireYearController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();

  bool _isProcessing = false;
 Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
List<OrderItem> convertProductsToOrderItems(List<Product> products) {
  return products.map((product) {
    return OrderItem(
      productId: product.id,
      quantity: product.stockAmount,
      price: product.price,
    );
  }).toList();
}
  void _processPayment() async{
    if (_formKey.currentState!.validate()) {
      setState(() => _isProcessing = true);
      var api = PaymentApi();
      final paymentRequest = {

        "price" : widget.totalPrice,
        'cardHolderName' : _cardHolderController.text,
        'cardNumber':_cardNumberController.text,
        'expireMonth':_expireMonthController.text,
        'expireYear': _expireYearController.text,
        'cvc' : _cvcController.text

      };
      var log =  Logger();
      var paymentResult = await api.Pay(paymentRequest);
      if(paymentResult.success)
      {
         var addOrder = OrderApi();
         var orderItems = convertProductsToOrderItems(widget.products);
         OrderRequestDto orderRequestDto = OrderRequestDto(
        order: Order(
          id: 0, // or the appropriate ID
          userId: await _getUserId(), // replace with actual user ID
          totalPrice: widget.totalPrice,
          userAddressId:await _getUserId() ,
          orderDate: null,
          paymentStatus: true, // or false based on payment result
          orderItems: orderItems,
        ),
        orderItems: orderItems,

      );
       await  addOrder.addOrder(orderRequestDto);


        log.d(paymentResult.message);
          showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: [
                // Optional logo
                Icon(Icons.check_circle, color: Colors.green, size: 40), 
                SizedBox(height: 10),
                Text(
                  "SİPARİŞİNİZ OLUŞTURULDU", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            content: Text("Hesabım > Siparişlerim 'den kontrol edebilirsiniz."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
        ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text(paymentResult.message ?? "Beklenmedik Hata"))
      );

      }
      else{
        log.d(paymentResult.message);

        ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text(paymentResult.message ?? "Beklenmedik Hata"))
    );
      }
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isProcessing = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Güvenli Ödeme")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Toplam Tutar : ${widget.totalPrice.toStringAsFixed(2)} TL",
                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _cardHolderController,
                  decoration: const InputDecoration(labelText: "Kart sahibi"),
                  validator: (value) => (value == null || value.isEmpty) ? "bu alan zorunludur" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Kart Numarası"),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                  ],
                  validator: (value) => (value != null && value.length == 16) ? null : "Geçersiz Kart",
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _expireMonthController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: "Ay"),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) return "bu alan zorunludur";
                          final month = int.tryParse(value);
                          if (month == null || month < 1 || month > 12) return "Geçersiz Ay";
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _expireYearController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: "Yıl"),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) return "bu alan zorunludur";
                          final year = int.tryParse(value);
                          if (year == null || year < DateTime.now().year % 100) return "Geçersiz Yıl";
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _cvcController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "CVC"),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  validator: (value) => (value != null && value.length == 3) ? null : "bu alan zorunludur",
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _processPayment,
                    child: _isProcessing ? const CircularProgressIndicator(color: Colors.white) : const Text("Onayla ve Bitir"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
