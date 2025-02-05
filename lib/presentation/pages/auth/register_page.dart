
import 'package:chinese_bazaar/Core/Helper/LegalDocuments.dart';
import 'package:chinese_bazaar/data/sources/login_api.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget{
  const RegisterPage({super.key});
  
  @override
  _RegisterPageState  createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage>{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isKvkkChecked = false;
  bool _isMembershipChecked = false;
  
  void _showAgreementDialog(String title, String content) {
  showDialog(
    context: context,
    builder: (context) {
      const closeText = "Kapat";
      return AlertDialog(
        title: Text(title),
        content: Container(
          height: 200, // Set a fixed height here
          child: SingleChildScrollView(child: Text(content)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(closeText),
          ),
        ],
      );
    },
  );
}
void _showDialog(String title, String content) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      );
    },
  );
}
String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Şifreyi tekrar giriniz";
    }
    if (value != _passwordController.text) {
      return "Şifreler eşleşmiyor";
    }
    return null;
  }
String? _emailValidatorFunc(String? value) {
  if (value == null || value.isEmpty) {
    return "E-posta adresi giriniz";
  }
  // E-posta formatı doğrulaması
  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return "Geçerli bir e-posta adresi giriniz";
  }
  return null;  // Eğer geçerliyse null döner
}


 
  @override
  Widget build(BuildContext context) {
     final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    const registerTitle = "Hesap Oluştur";
    var createAccountText = "Hesap Oluşturun";
    const _labelEmail = "Email";
    const _labelPassword = "Şifre Giriniz";
    const _passwordValidator = "Şifre en az 6 haneli olmalı";
    const _labelPasswordAgain = "Şifreyi Tekrar Giriniz";
    
  const _membershipInformation = "Üyelik Sözleşmesini okudum ve kabul ediyorum.";
    const _kvkkInformation = "Kvkk metnini okudum ve Kabul ediyorum";
    const _kvkkInformationTitle = "KİŞİSEL VERİLERİN KORUNMASI VE İŞLENMESİNE İLİŞKİN AYDINLATMA METNİ";
    const _membershipInformationTitle = "ÜYELİK SÖZLEŞMESİ";
    const _register = "Hesap oluştur";
    return Scaffold(
      appBar: AppBar(
        title: const Text(registerTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color:Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.05),
              Text(createAccountText,
              style: TextStyle(fontSize: screenWidth *0.05,
              fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.05),
              // TextFormField(
              //   decoration: const InputDecoration(labelText: _labelFirstName,border: OutlineInputBorder()),
              //   validator: (value) => value!.isEmpty ? _firstNameValidator : null,
              // ),
              // SizedBox(height: screenHeight * 0.02),

              // TextFormField(
              //   decoration: const InputDecoration(labelText: _labelLastName,border: OutlineInputBorder()),
              //   validator: (value) => value!.isEmpty ? _lastNameValidator : null,
              // ),
              // SizedBox(height: screenHeight * 0.02),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: _labelEmail,border: OutlineInputBorder()),
                validator: _emailValidatorFunc,
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                controller: _passwordController,
                 decoration: const InputDecoration(labelText: _labelPassword,
                 border: OutlineInputBorder()),
                 obscureText: true,
                 validator: (value) => value!.length < 6 ? _passwordValidator : null,
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                controller: _confirmPasswordController,
                 decoration: const InputDecoration(labelText: _labelPasswordAgain,
                 border: OutlineInputBorder()),
                 obscureText: true,
                 
                 validator: _confirmPasswordValidator,
              ),
              SizedBox(height: screenHeight * 0.02),
              CheckboxListTile(
                title: GestureDetector(
                  onTap: () => _showAgreementDialog(_kvkkInformationTitle,LegalDocuments.kvkkMetni),
                  child: const Text(_kvkkInformation, style: TextStyle(decoration: TextDecoration.underline,color:Colors.black),
                ),
                ),
                value: _isKvkkChecked,
                onChanged: (value) => setState(() => _isKvkkChecked = value!),
              ),
              CheckboxListTile(
                title: GestureDetector(
                  onTap: () => _showAgreementDialog(_membershipInformationTitle,LegalDocuments.uyeSozlesmesi),
                  child: const Text(_membershipInformation, style: TextStyle(decoration: TextDecoration.underline,color:Colors.black),
                ),
                ),
                value: _isMembershipChecked,
                onChanged: (value) => setState(() => _isMembershipChecked = value!),
              ),
              SizedBox(height: screenHeight * 0.02),
         ElevatedButton(
  onPressed: (_isKvkkChecked && _isMembershipChecked)
      ? () async {
          if (_formKey.currentState!.validate()) {
            var registerApi = AuthApi();
            final response = await registerApi.register(_emailController.text, _passwordController.text);

            if (response != null) {
              String errorMessage = "Kayıt başarısız! Lütfen tekrar deneyin.";

              // 📌 API response formatına göre hata mesajını çek
              if (response.containsKey("message")) {
                errorMessage = response["message"].toString();
              } else if (response.containsKey("errors")) {
                var errors = response["errors"];
                if (errors is Map && errors.containsKey("email")) {
                  errorMessage = errors["email"][0]; // İlk hata mesajını al
                }
              }

              // Eğer kullanıcı zaten varsa uygun mesajı göster
              if (errorMessage.contains("Kullanıcı Zaten Var")) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Bu e-posta ile zaten bir hesap var!")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(errorMessage)),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Kayıt başarısız! Lütfen tekrar deneyin.")),
              );
            }
          }
        }
      : null,
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.orange,
    minimumSize: Size(screenWidth * 0.8, screenHeight * 0.06),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  child: Text(
    _register,
    style: TextStyle(
      fontSize: screenWidth * 0.05,
      fontWeight: FontWeight.bold,
      color: Colors.black38,
    ),
  ),
),



              
            ],
          ),
        ),
      ),



    );





  }
}