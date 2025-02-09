

import 'dart:convert';
import 'dart:io';

import 'package:chinese_bazaar/data/sources/order_api.dart';

class PaymentResult{
  late bool success;
  late String? message;
  PaymentResult({required this.success, this.message});

}
 class PaymentRequest
{   
    late String price;
    late String cardHolderName ;
    late String cardNumber ;
    late String expireMonth ;
    late String expireYear ;
    late String cvc ;

    // Map<String,dynamic> toJson(){
    //   return
    //   {
    //     'price': price,
    //     'cardHolderName' : cardHolderName,
    //     'cardNumber':cardNumber,
    //     'expireMonth':expireMonth,
    //     'expireear':expireYear,
    //     'cvc' : cvc
      
    //   };
    // }
    
}

class PaymentApi
{
  late String baseUrl = "https://192.168.18.199:5001/api/Payment/payment";

 Future<PaymentResult> Pay(Map<String, dynamic> paymentRequest) async {
  final httpClient = HttpClient();
  httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;

  final request = await httpClient.postUrl(Uri.parse(baseUrl));

  // Set Content-Type header
  request.headers.set(HttpHeaders.contentTypeHeader, "application/json");

  request.write(jsonEncode(paymentRequest));

  final response = await request.close();

  final responseBody = await response.transform(utf8.decoder).join();

  if (response.statusCode >= 200 && response.statusCode <= 299) {
   
    final Map<String, dynamic> responseData = jsonDecode(responseBody);
    return PaymentResult(success: true, message: responseData.toString());
  } else {
    return PaymentResult(success: false, message: responseBody);
  }
}

}
