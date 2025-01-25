import 'package:chinese_bazaar/data/sources/address_api.dart';
import 'package:chinese_bazaar/presentation/pages/displayUserAddress.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAddress extends StatefulWidget {
  const UserAddress({super.key});

  @override
  _UserAddressState createState() => _UserAddressState();
}

class _UserAddressState extends State<UserAddress> {
  final AddressApi _addressApi = AddressApi();
  List<Map<String, dynamic>> cities = [];
  List<Map<String, dynamic>> districts = [];
  List<Map<String, dynamic>> neighborhoods = [];
  
  int? selectedCity;
  int? selectedDistrict;
  int? selectedNeighborhood;

  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? addressDescription;

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  // Load Cities
  _loadCities() async {
    var fetchedCities = await _addressApi.getCities();
    setState(() {
      cities = fetchedCities;
    });
  }

  // Load Districts based on selected city
  _loadDistricts(int cityId) async {
    var fetchedDistricts = await _addressApi.getDistricts(cityId);
    setState(() {
      districts = fetchedDistricts;
      selectedDistrict = null;  // Reset district when city changes
      neighborhoods = [];  // Reset neighborhoods
      selectedNeighborhood = null;  // Reset neighborhood selection
    });
  }

  // Load Neighborhoods based on selected district
  _loadNeighborhoods(int districtId) async {
    setState(() {
      isLoading = true;  // Set loading state to true
    });

    var fetchedNeighborhoods = await _addressApi.getNeighborhoods(districtId);
    
    setState(() {
      neighborhoods = fetchedNeighborhoods;
      isLoading = false;  // Set loading state to false after data is fetched
    });
  }

  // Submit form
  _submitForm() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    try {
      // Retrieve userId from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      final existingAddress = await _addressApi.getUserAddress(userId);

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("İnternet bağlantınızı kontrol edin")),
        );
        return;
      }

      final userAddress = {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "addressDescription": addressDescription,
        "cityId": selectedCity,
        "districtId": selectedDistrict,
        "neighborhoodId": selectedNeighborhood,
      };

      // Save user address via API
      bool success;
      if (existingAddress != null) {
        // Update existing address
        success = await _addressApi.updateUserAddress(userAddress);
      } else {
        // Add new address
        success = await _addressApi.saveUserAddress(userAddress);
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Adres kayıt edildi")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save address. Please try again.")),
        );
        return;
      }

      // Navigate to AddressDisplayPage and replace the current page
       Navigator.pop(context);

      // Ensure no further execution after navigation
  
    } catch (e) {
      // Handle unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Adres")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Information Section
              const Text('İletişim Bilgileri', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Ad'),
                validator: (value) => value!.isEmpty ? 'Adınızı girin' : null,
                onSaved: (value) => firstName = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Soyad'),
                validator: (value) => value!.isEmpty ? 'Soyadınızı girin' : null,
                onSaved: (value) => lastName = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Telefon numarası'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'telefon numarası girin' : null,
                onSaved: (value) => phoneNumber = value,
              ),
              const SizedBox(height: 16),

              // Address Information Section
              const Text('Adres Bilgileri', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Center(
                child: SizedBox(
                  width: screenWidth > 600 ? 400 : double.infinity, // Yatay genişlik kontrolü
                  child: DropdownButtonFormField<int>(
                    value: selectedCity,
                    hint: const Text("Şehir seç", style: TextStyle(fontSize: 14)),
                    onChanged: (value) {
                      setState(() {
                        selectedCity = value;
                        _loadDistricts(value!);  // Load districts when city changes
                      });
                    },
                    onSaved: (value) => selectedCity = value,
                    items: cities.map((city) {
                      return DropdownMenuItem<int>(
                        value: city['id'],
                        child: Text(city['name'], style: const TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                    validator: (value) => value == null ? 'Şehir seç' : null,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    dropdownColor: Colors.white,
                    menuMaxHeight: 200,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: screenWidth > 600 ? 400 : double.infinity, 
                child: DropdownButtonFormField<int>(
                  value: selectedDistrict,
                  hint: const Text("İlçe seç", style: TextStyle(fontSize: 14)),
                  onChanged: (value) {
                    setState(() {
                      selectedDistrict = value;
                      selectedNeighborhood = null;  // Reset neighborhood when district changes
                      _loadNeighborhoods(value!);  // Load neighborhoods when district changes
                    });
                  },
                  onSaved: (value) => selectedDistrict = value,
                  items: districts.map((district) {
                    return DropdownMenuItem<int>(
                      value: district['id'],
                      child: Text(district['name'], style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'İlçe seç' : null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  dropdownColor: Colors.white,
                  menuMaxHeight: 200,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: screenWidth > 600 ? 400 : double.infinity,
                child: DropdownButtonFormField<int>(
                  value: selectedNeighborhood,
                  hint: const Text("Mahalle Seç"),
                  onChanged: (value) {
                    setState(() {
                      selectedNeighborhood = value;
                    });
                  },
                  onSaved: (value) => selectedNeighborhood = value,
                  items: isLoading 
                      ? [const DropdownMenuItem(child: Center(child: CircularProgressIndicator()))] // Show loading indicator
                      : neighborhoods.map((neighborhood) {
                          return DropdownMenuItem<int>(
                            value: neighborhood['id'],
                            child: Text(neighborhood['name']),
                          );
                        }).toList(),
                  validator: (value) => value == null ? 'Mahalle seç' : null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  dropdownColor: Colors.white,
                  menuMaxHeight: 200,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
  decoration: const InputDecoration(
    labelText: 'Adres',
    hintText: "Kat daire apart sokak bilgilerini gir",
  ),
  onSaved: (value) => addressDescription = value,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "Bu alanı doldurun";  // Check if the field is empty
    } else if (value.length < 10) {
      return "apart daire ve sokak bilgilerini gir";  // Check if the length is less than 10
    }
    return null;  // Return null if validation is successful
  },
),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Kaydet',style: TextStyle(fontSize: 20),),
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}