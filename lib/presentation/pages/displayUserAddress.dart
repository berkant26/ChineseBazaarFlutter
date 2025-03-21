import 'package:chinese_bazaar/data/sources/address_api.dart';
import 'package:chinese_bazaar/presentation/pages/UserAddress.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressDisplayPage extends StatefulWidget {
  const AddressDisplayPage({super.key});

  @override
  _AddressDisplayPageState createState() => _AddressDisplayPageState();
}

class _AddressDisplayPageState extends State<AddressDisplayPage> {
  final AddressApi _addressApi = AddressApi();
  Map<String, dynamic>? _userAddress;
  bool _isLoading = true;
  var logger = Logger();
  @override
  void initState() {
    super.initState();
    _fetchUserAddress();
  }

  Future<void> _fetchUserAddress() async {
    try {
      // Retrieve userId from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      logger.d("kullanici userId = $userId");
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Giriş Yap")),
        );
        return;
      }

      // Fetch user address from API
      final address = await _addressApi.getUserAddress(userId);

      setState(() {
        _userAddress = address;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching address: $e")),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Adres bilgileriniz"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _userAddress == null
              ? Center(child: Text("Kayıtlı adresiniz Yok. Sağ alttaki butonla ekleyebilirsin"))
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05, // 5% of screen width
                    vertical: screenHeight * 0.02, // 2% of screen height
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow("Ad", _userAddress!['firstName'], screenWidth),
                      _buildInfoRow("Soyad", _userAddress!['lastName'], screenWidth),
                      _buildInfoRow("Telefon", _userAddress!['phoneNumber'], screenWidth),
                      _buildInfoRow("Açık Adres", _userAddress!['addressDescription'], screenWidth),
                      _buildInfoRow("Şehir", _userAddress!['cityName'].toString(), screenWidth),
                      _buildInfoRow("İlçe", _userAddress!['districtName'].toString(), screenWidth),
                      _buildInfoRow("Mahalle", _userAddress!['neighborhoodName'].toString(), screenWidth),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the address edit page
                           Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const UserAddress(
    
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child; // No transition animation
    },
  ),
);
                        },
                        child: Text("Düzenle"),
                      ),
                    ],
                  ),
                ),
     floatingActionButton: FutureBuilder(
  future: Future.delayed(const Duration(seconds: 2), () {
    return _userAddress == null;
  }),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Container();  // Optionally, show an empty container or a loading indicator while waiting
    } else if (snapshot.hasData && snapshot.data == true) {
      return FloatingActionButton(
        onPressed: () {
          // Navigate to the address add page
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const UserAddress(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return child; // No transition animation
              },
            ),
          );
        },
        tooltip: "Add Address",
        child: const Icon(Icons.add),
      );
    } else {
      return Container();  // Return an empty container if the condition is not met
    }
  },
),
    );
  }

  Widget _buildInfoRow(String label, String value, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.02), // Dynamic spacing
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.045, // Adjust font size dynamically
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: screenWidth * 0.04, // Adjust font size dynamically
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
